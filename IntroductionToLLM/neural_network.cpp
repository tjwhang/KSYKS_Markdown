/**
 * *doxygen은 md를 지원함.
 * # 간단한 인공 신경망
 * C++17, STL만 사용
 * ## 기능
 * - "조밀한" 계층, 활성화함수 지수 시그모이드/쌍곡탄젠트/ReLU/항등, softmax + 교차 엔트로피
 * - SGD 최적화
 * - 순전파, 역전파 및 학습 유틸리티
 * - 8 x 8 (64차원) 이진 이미지 분류
 *
 */

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <exception>
#include <iomanip>
#include <iostream>
#include <limits>
#include <numeric>
#include <random>
#include <stdexcept>
#include <string>
#include <tuple>
#include <utility>
#include <vector>
#include <memory>

// <출력용 전역 선언>
const std::string shades = " .:-=+*#%@"; // 아스키 아트 원리로 어두울수록 더 자리 많이 차지하는 문자 보여주기. 현재는 0, 1밖에 없지만 추후 그 사이 값을 갖는 픽셀도 다룰 수 있음.

// <수학적 기반 자료구조>

// 행렬/텐서
struct Matrix
{
    size_t rows{0}, cols{0};
    std::vector<double> data;

    Matrix() = default;
    Matrix(size_t r, size_t c, double v = 0.0) : rows(r), cols(c), data(r * c, v) {}

    double &operator()(size_t r, size_t c) { return data[r * cols + c]; }
    double operator()(size_t r, size_t c) const { return data[r * cols + c]; }

    static Matrix zeros(size_t r, size_t c) { return Matrix(r, c, 0.0); }
};

// 전치
static Matrix transpose(const Matrix &A)
{
    Matrix T(A.cols, A.rows);
    for (size_t r = 0; r < A.rows; ++r)
        for (size_t c = 0; c < A.cols; ++c)
            T(c, r) = A(r, c);
    return T;
}

// 행렬곱
static Matrix matmul(const Matrix &A, const Matrix &B)
{
    if (A.cols != B.rows)
        throw std::runtime_error("행렬곱: 차원 불일치");
    Matrix C(A.rows, B.cols, 0.0);
    for (size_t i = 0; i < A.rows; ++i)
    {
        for (size_t k = 0; k < A.cols; ++k)
        {
            double a = A(i, k);
            const size_t Brow = k * B.cols;
            const size_t Crow = i * C.cols;
            for (size_t j = 0; j < B.cols; ++j)
            {
                C.data[Crow + j] += a * B.data[Brow + j];
            }
        }
    }
    return C;
}

// 바이어스 더하기
static void add_bias_inplace(Matrix &Z, const std::vector<double> &b)
{
    if (Z.cols != b.size())
        throw std::runtime_error("바이어스: 행렬 차원 불일치");
    for (size_t i = 0; i < Z.rows; ++i)
        for (size_t j = 0; j < Z.cols; ++j)
            Z(i, j) += b[j];
}

// 행 더하기
static Matrix sum_rows(const Matrix &A)
{
    Matrix s(1, A.cols, 0.0);
    for (size_t i = 0; i < A.rows; ++i)
        for (size_t j = 0; j < A.cols; ++j)
            s(0, j) += A(i, j);
    return s;
}

// 행렬 간 차
static Matrix operator-(const Matrix &A, const Matrix &B)
{
    if (A.rows != B.rows || A.cols != B.cols)
        throw std::runtime_error("차: 행렬 차원 불일치");
    Matrix C(A.rows, A.cols);
    for (size_t i = 0; i < A.data.size(); ++i)
        C.data[i] = A.data[i] - B.data[i];
    return C;
}

// 행렬 간 합
static Matrix operator+(const Matrix &A, const Matrix &B)
{
    if (A.rows != B.rows || A.cols != B.cols)
        throw std::runtime_error("합: 행렬 차원 불일치");
    Matrix C(A.rows, A.cols);
    for (size_t i = 0; i < A.data.size(); ++i)
        C.data[i] = A.data[i] + B.data[i];
    return C;
}

// 실수배
static Matrix operator*(const Matrix &A, double s)
{
    Matrix C(A.rows, A.cols);
    for (size_t i = 0; i < A.data.size(); ++i)
        C.data[i] = A.data[i] * s;
    return C;
}

// 선형결합 A_i = A_i + alpha X_i
static void axpy_inplace(Matrix &A, const Matrix &X, double alpha)
{
    if (A.rows != X.rows || A.cols != X.cols)
        throw std::runtime_error("선형결합: 행렬 차원 불일치");
    for (size_t i = 0; i < A.data.size(); ++i)
        A.data[i] += alpha * X.data[i];
}

// 벡터 선형결합 a_i = a_i + alpha x_i
static void axpy_inplace_vec(std::vector<double> &a, const std::vector<double> &x, double alpha)
{
    if (a.size() != x.size())
        throw std::runtime_error("선형결합: 행렬 차원 불일치");
    for (size_t i = 0; i < a.size(); ++i)
        a[i] += alpha * x[i];
}

// 영벡터
static std::vector<double> zeros_vec(size_t n) { return std::vector<double>(n, 0.0); }

// 가장 큰 원소가 속한 행 반환
static size_t argmax_row(const Matrix &A, size_t r)
{
    size_t idx = 0;
    double best = -std::numeric_limits<double>::infinity();
    for (size_t j = 0; j < A.cols; ++j)
    {
        if (A(r, j) > best)
        {
            best = A(r, j);
            idx = j;
        }
    }
    return idx;
}

// <난수생성, 초기화>

// 난수 생성기 (random number generator). x in [a, b) 난수 생성
struct RNG
{
    std::mt19937_64 gen; // 필기: Mersenne twister 알고리즘 기반 2^19937 - 1 주기의 x64 STL 난수 생성기. 고맙다 GPT
    explicit RNG(uint64_t seed = std::random_device{}()) : gen(seed) {}

    double uniform(double a, double b)
    {
        std::uniform_real_distribution<double> dist(a, b);
        return dist(gen);
    }
};

// Xavier uniform 신경망 초기화 알고리즘
static Matrix xavier_uniform(size_t in_dim, size_t out_dim, RNG &rng)
{
    double limit = std::sqrt(6.0 / static_cast<double>(in_dim + out_dim));
    Matrix W(in_dim, out_dim);
    for (double &w : W.data)
        w = rng.uniform(-limit, limit);
    return W;
}

// <활성화 함수>

// 활성화 함수 "인터페이스"... (UE C++가 그리운 부분)
struct IActivation
{
    virtual ~IActivation() = default;
    virtual Matrix forward(const Matrix &Z) = 0;
    virtual Matrix backward(const Matrix &dA) = 0; // 순전파 시 캐시 필요
};

// 활성화 함수들 구현은 GPT 참고
struct ReLU : IActivation
{
    Matrix cacheZ;
    Matrix forward(const Matrix &Z) override
    {
        cacheZ = Z;
        Matrix A(Z.rows, Z.cols);
        for (size_t i = 0; i < Z.data.size(); ++i)
            A.data[i] = std::max(0.0, Z.data[i]);
        return A;
    }
    Matrix backward(const Matrix &dA) override
    {
        if (cacheZ.rows != dA.rows || cacheZ.cols != dA.cols)
            throw std::runtime_error("ReLU 역전파: 차원 불일치");
        Matrix dZ(dA.rows, dA.cols);
        for (size_t i = 0; i < dA.data.size(); ++i)
            dZ.data[i] = (cacheZ.data[i] > 0.0) ? dA.data[i] : 0.0;
        return dZ;
    }
};

struct Sigmoid : IActivation
{
    Matrix cacheA;
    Matrix forward(const Matrix &Z) override
    {
        Matrix A(Z.rows, Z.cols);
        for (size_t i = 0; i < Z.data.size(); ++i)
            A.data[i] = 1.0 / (1.0 + std::exp(-Z.data[i]));
        cacheA = A;
        return A;
    }
    Matrix backward(const Matrix &dA) override
    {
        Matrix dZ(dA.rows, dA.cols);
        for (size_t i = 0; i < dA.data.size(); ++i)
            dZ.data[i] = dA.data[i] * cacheA.data[i] * (1.0 - cacheA.data[i]);
        return dZ;
    }
};

struct Tanh : IActivation
{
    Matrix cacheA;
    Matrix forward(const Matrix &Z) override
    {
        Matrix A(Z.rows, Z.cols);
        for (size_t i = 0; i < Z.data.size(); ++i)
            A.data[i] = std::tanh(Z.data[i]);
        cacheA = A;
        return A;
    }
    Matrix backward(const Matrix &dA) override
    {
        Matrix dZ(dA.rows, dA.cols);
        for (size_t i = 0; i < dA.data.size(); ++i)
            dZ.data[i] = dA.data[i] * (1.0 - cacheA.data[i] * cacheA.data[i]);
        return dZ;
    }
};

struct Identity : IActivation
{
    Matrix forward(const Matrix &Z) override { return Z; }
    Matrix backward(const Matrix &dA) override { return dA; }
};

// <계층>

struct ILayer
{
    virtual ~ILayer() = default;
    virtual Matrix forward(const Matrix &X) = 0;
    virtual Matrix backward(const Matrix &dA) = 0;
    virtual void step(double lr, double weight_decay = 0.0) = 0;
    virtual size_t params() const = 0;
};

// 싹 다 연결된 일반적인 "dense" 계층
struct Dense : ILayer
{
    Matrix W;              // dim in x dim out
    std::vector<double> b; // dim out

    // 캐시
    Matrix X_cache;         // 순전파 입력 저장, dim batch x dim in
    Matrix Z_cache;         // 순전파 선형 변환 결과 저장, dim batch x dim out
    Matrix dW;              // 역전파 시 가중치 그라디언트, dim in x dim out
    std::vector<double> db; // 역전파 시 바이어스 그라디언트, dim out

    std::unique_ptr<IActivation> act;

    // 생성자: Xavier 초기화, 바이어스는 0
    Dense(size_t in_dim, size_t out_dim, std::unique_ptr<IActivation> activation, RNG &rng)
        : W(xavier_uniform(in_dim, out_dim, rng)), b(out_dim, 0.0), act(std::move(activation)) {}

    Matrix forward(const Matrix &X) override
    {
        if (X.cols != W.rows)
            throw std::runtime_error("순전파: 차원 불일치");
        X_cache = X;

        // z = W x + b
        Z_cache = matmul(X, W);
        add_bias_inplace(Z_cache, b);

        // sigma(z)
        return act->forward(Z_cache);
    }

    Matrix backward(const Matrix &dA) override
    {
        Matrix dZ = act->backward(dA); // dim batch x dim out
        // 그라디언트
        Matrix Xt = transpose(X_cache); // dim in x dim batch
        dW = matmul(Xt, dZ);            // dim in x dim out
        Matrix ones = sum_rows(dZ);     // 1 x dim out
        db.assign(b.size(), 0.0);
        for (size_t j = 0; j < b.size(); ++j)
            db[j] = ones(0, j);
        // 그라디언트 입력
        Matrix Wt = transpose(W);   // dim out x dim in
        Matrix dX = matmul(dZ, Wt); // dim batch x dim in
        return dX;
    }

    void step(double lr, double weight_decay = 0.0) override
    {
        // L2 정규화 가중치 감쇠
        if (weight_decay != 0.0)
        {
            for (size_t i = 0; i < W.data.size(); ++i)
                W.data[i] *= (1.0 - lr * weight_decay);
        }
        // SGD 업데이트
        for (size_t i = 0; i < W.data.size(); ++i)
            W.data[i] -= lr * dW.data[i];
        for (size_t j = 0; j < b.size(); ++j)
            b[j] -= lr * db[j];
    }

    size_t params() const override { return W.data.size() + b.size(); }
};

// <비용함수: softmax 교차 엔트로피>

struct CrossEntropyWithLogits
{
    // 순전파에서 비용함수 기댓값 반환
    double forward(const Matrix &logits, const std::vector<int> &y)
    {
        if (logits.rows != y.size())
            throw std::runtime_error("CE: 배치 차원 불일치");
        double total = 0.0;
        tmp_softmax = Matrix(logits.rows, logits.cols);
        for (size_t i = 0; i < logits.rows; ++i)
        {
            // log-sum-exp for stability
            double maxv = -std::numeric_limits<double>::infinity();
            for (size_t j = 0; j < logits.cols; ++j)
                maxv = std::max(maxv, logits(i, j));
            double sumexp = 0.0;
            for (size_t j = 0; j < logits.cols; ++j)
            {
                double e = std::exp(logits(i, j) - maxv);
                tmp_softmax(i, j) = e;
                sumexp += e;
            }
            double logsumexp = std::log(sumexp) + maxv;
            int label = y[i];
            if (label < 0 || static_cast<size_t>(label) >= logits.cols)
                throw std::runtime_error("CE: label out of range");
            total += -logits(i, label) + logsumexp;
            // softmax 열 정규화
            for (size_t j = 0; j < logits.cols; ++j)
                tmp_softmax(i, j) /= sumexp;
        }
        return total / static_cast<double>(logits.rows);
    }

    // 역전파에서 dLogits 반환 (배치 x 클래스)
    Matrix backward(const Matrix &logits, const std::vector<int> &y)
    {
        if (logits.rows != y.size())
            throw std::runtime_error("CE: 배치 차원 불일치");
        Matrix grad = tmp_softmax; // 이미 softmax
        for (size_t i = 0; i < logits.rows; ++i)
        {
            grad(i, y[i]) -= 1.0;
        }
        // 배치에서 기댓값
        double invB = 1.0 / static_cast<double>(logits.rows);
        for (double &g : grad.data)
            g *= invB;
        return grad;
    }

private:
    Matrix tmp_softmax; // 순전파/역전파 간 캐시
};

// <신경망>

struct NeuralNetwork
{
    std::vector<std::unique_ptr<ILayer>> layers;

    Matrix forward(const Matrix &X)
    {
        Matrix out = X;
        for (auto &ly : layers)
            out = ly->forward(out);
        return out;
    }

    // dLoss/dOut 부터 역전파 시작
    void backward(const Matrix &dOut)
    {
        Matrix grad = dOut;
        for (size_t i = layers.size(); i-- > 0;)
        {
            grad = layers[i]->backward(grad);
        }
    }

    void step(double lr, double weight_decay = 0.0)
    {
        for (auto &ly : layers)
            ly->step(lr, weight_decay);
    }

    size_t params() const
    {
        size_t p = 0;
        for (auto &ly : layers)
            p += ly->params();
        return p;
    }
};

// <학습할 때 써먹는거(유틸리티)>

struct SGDConfig
{
    double lr{0.05};
    double weight_decay{0.0};
    size_t epochs{10};
    size_t batch_size{16};
    uint64_t seed{42};
};

static std::vector<size_t> shuffled_indices(size_t n, std::mt19937_64 &g)
{
    std::vector<size_t> idx(n);
    std::iota(idx.begin(), idx.end(), 0);
    std::shuffle(idx.begin(), idx.end(), g);
    return idx;
}

struct History
{
    std::vector<double> loss;
    std::vector<double> acc;
};

static double accuracy(const Matrix &logits, const std::vector<int> &y)
{
    size_t correct = 0;
    for (size_t i = 0; i < logits.rows; ++i)
        if (static_cast<int>(argmax_row(logits, i)) == y[i])
            ++correct;
    return static_cast<double>(correct) / static_cast<double>(logits.rows);
}

static History fit(NeuralNetwork &net, CrossEntropyWithLogits &loss_fn,
                   const Matrix &X, const std::vector<int> &y,
                   const SGDConfig &cfg)
{
    if (X.rows != y.size())
        throw std::runtime_error("학습: X/y 차원 불일치");
    History hist;
    RNG rng(cfg.seed);

    const size_t N = X.rows;
    std::vector<size_t> order(N);

    for (size_t epoch = 0; epoch < cfg.epochs; ++epoch)
    {
        // Shuffle
        order = shuffled_indices(N, rng.gen);
        double epoch_loss = 0.0;
        size_t seen = 0;

        for (size_t start = 0; start < N; start += cfg.batch_size)
        {
            size_t end = std::min(N, start + cfg.batch_size);
            size_t B = end - start;
            // 미니 배치
            Matrix Xb(B, X.cols);
            std::vector<int> yb(B);
            for (size_t i = 0; i < B; ++i)
            {
                size_t idx = order[start + i];
                yb[i] = y[idx];
                for (size_t j = 0; j < X.cols; ++j)
                    Xb(i, j) = X(idx, j);
            }

            // 순전파
            Matrix logits = net.forward(Xb);
            double L = loss_fn.forward(logits, yb);
            epoch_loss += L * static_cast<double>(B);

            // 역전파
            Matrix dlogits = loss_fn.backward(logits, yb);
            net.backward(dlogits);
            net.step(cfg.lr, cfg.weight_decay);

            seen += B;
        }
        epoch_loss /= static_cast<double>(N);

        // Evaluate on train set (quick)
        Matrix logits = net.forward(X);
        double accv = accuracy(logits, y);
        hist.loss.push_back(epoch_loss);
        hist.acc.push_back(accv);
        std::cout << "에포크 " << (epoch + 1) << "/" << cfg.epochs
                  << " - 손실(비용): " << std::fixed << std::setprecision(4) << epoch_loss
                  << " - 정확도: " << std::setprecision(4) << accv << "\n";
    }
    return hist;
}

// <8 x 8 이미지 관련>

// 정수 0, 1을 64차원 double [0,1]로 flatten
static std::vector<double> flatten8x8(const std::vector<std::vector<int>> &img8x8)
{
    if (img8x8.size() != 8)
        throw std::runtime_error("flatten8x8: need 8 rows");
    std::vector<double> out;
    out.reserve(64);
    for (size_t r = 0; r < 8; ++r)
    {
        if (img8x8[r].size() != 8)
            throw std::runtime_error("flatten8x8: need 8 cols");
        for (size_t c = 0; c < 8; ++c)
            out.push_back(img8x8[r][c] ? 1.0 : 0.0);
    }
    return out;
}

static Matrix to_matrix(const std::vector<std::vector<double>> &rows)
{
    if (rows.empty())
        return Matrix();
    size_t R = rows.size();
    size_t C = rows[0].size();
    Matrix M(R, C);
    for (size_t i = 0; i < R; ++i)
    {
        if (rows[i].size() != C)
            throw std::runtime_error("to_matrix: ragged rows");
        for (size_t j = 0; j < C; ++j)
            M(i, j) = rows[i][j];
    }
    return M;
}

// <테스트용 데이터셋 생성기>
/**
 * 1. 네 개의 8x8 모양을 생성: +, X, ㅁ, \
 * 2. 노이즈 적용해서 다양화하기
 */

static std::vector<std::vector<int>> pattern_plus()
{
    std::vector<std::vector<int>> g(8, std::vector<int>(8, 0));
    for (int i = 0; i < 8; ++i)
    {
        g[3][i] = 1;
        g[i][3] = 1;
    }
    return g;
}
static std::vector<std::vector<int>> pattern_x()
{
    std::vector<std::vector<int>> g(8, std::vector<int>(8, 0));
    for (int i = 0; i < 8; ++i)
    {
        g[i][i] = 1;
        g[i][7 - i] = 1;
    }
    return g;
}
static std::vector<std::vector<int>> pattern_box()
{
    std::vector<std::vector<int>> g(8, std::vector<int>(8, 0));
    for (int i = 0; i < 8; ++i)
    {
        g[0][i] = g[7][i] = g[i][0] = g[i][7] = 1;
    }
    return g;
}
static std::vector<std::vector<int>> pattern_diag()
{
    std::vector<std::vector<int>> g(8, std::vector<int>(8, 0));
    for (int i = 0; i < 8; ++i)
        g[i][i] = 1;
    return g;
}

static void add_noise(std::vector<double> &v, double prob, RNG &rng)
{
    std::uniform_real_distribution<double> u(0.0, 1.0);
    for (double &x : v)
    {
        if (u(rng.gen) < prob)
            x = 1.0 - x; // NOT 게이트 (비트 반전)
    }
}

static void make_synthetic_dataset(Matrix &X, std::vector<int> &y, size_t per_class = 32, uint64_t seed = 123)
{
    RNG rng(seed);
    std::vector<std::vector<int>> base[4] = {pattern_plus(), pattern_x(), pattern_box(), pattern_diag()};

    const size_t C = 4;
    const size_t N = per_class * C;
    X = Matrix(N, 64);
    y.assign(N, 0);

    size_t idx = 0;
    for (size_t cls = 0; cls < C; ++cls)
    {
        for (size_t n = 0; n < per_class; ++n)
        {
            auto fv = flatten8x8(base[cls]);
            // add small random flips
            add_noise(fv, 0.05, rng);
            std::cout << "\n라벨: " << cls << "\n";
            for (int i = 0; i < 8; i++)
            {
                for (int j = 0; j < 8; j++)
                {
                    double v = fv[j * 8 + i];
                    int idx = static_cast<int>(v * (shades.size() - 1));
                    if (idx < 0)
                        idx = 0;
                    if (idx >= (int)shades.size())
                        idx = shades.size() - 1;
                    char c = shades[idx];
                    std::cout << c << c; // 모노스페이스 문자가 얇아서 두번 출력
                }
                std::cout << "\n";
            }

            for (size_t j = 0; j < 64; ++j)
                X(idx, j) = fv[j];
            y[idx] = static_cast<int>(cls);
            ++idx;
        }
    }
}

/**
 * <8 x 8 데이터 학습 방법>
 * - 데이터 포맷: 정수 0, 1의 8 x 8 벡터 배열, flatten8x8로 64차원 double로 flatten하기, 라벨은 정수
 * - 모델: 입력계층 차원은 64, 각 계층 당 활성화 함수 지정
 * - 학습시키기는 방법
 * 1) 데이터셋 배열 만들기: `Matrix X(N, 64)`, `vector<int> y(N)`
 * 2) `X(i, j)`를 flatten한 샘플 i로 fill, `y[i]`는 라벨로 fill
 * 3) `num_classes` 알맞게 지정
 * 4) `SGDConfig`에서 하이퍼파라미터(학습률(`lr`), 에포크, 배치 크기, 가중치 감쇠 + L2) 지정
 * 5) `fit` 호출
 * - 분류시키기: (1, 64)의 `Matrix` 생성, `net.forward` 호출해 logit 도출, argmax로 클래스 유추
 */

// <학습시키는 양식>
// // 1) 클래스 개수 지정
// const size_t num_classes = /* 예) 10 */;

// // 2) 데이터셋 생성
// const size_t N = /* 샘플 개수 */;
// Matrix X(N, 64);
// std::vector<int> y(N);

// // Fill X, y
// for (size_t i = 0; i < N; ++i)
// {
//     // Suppose you have img8x8_i as std::vector<std::vector<int>>(8, std::vector<int>(8))
//     auto fv = flatten8x8(img8x8_i);
//     for (size_t j = 0; j < 64; ++j)
//         X(i, j) = fv[j];
//     y[i] = /* class id for sample i */;
// }

// // 3) 하이퍼파라미터 설정, 학습
// CrossEntropyWithLogits celoss;
// SGDConfig cfg;
// cfg.lr = 0.1;            // 학습률: 알잘딱
// cfg.epochs = 50;         // 에포크: 알잘딱
// cfg.batch_size = 32;     // 배치크기: 알잘딱
// cfg.weight_decay = 1e-4; // L2 가중치 감쇠: 필수 아님, 알잘딱
// auto hist = fit(net, celoss, X, y, cfg);

// // 4) 분류 테스트
// Matrix X1(1, 64);
// auto fv = flatten8x8(my_8x8);
// for (size_t j = 0; j < 64; ++j)
//     X1(0, j) = fv[j];
// Matrix logits = net.forward(X1);
// size_t pred = argmax_row(logits, 0);
// std::cout << "예측: 클래스 " << pred << "\n";

// main

int main()
{
    try
    {
        std::cout << "신경망 생성 중, 기다리세요..." << "\n";

        // 1) 신경망 만들기, 계층 64(입력) -> 32(은닉1) -> 16(은닉2) -> const(출력)
        const size_t input_dim = 64;
        const size_t num_classes = 4; // 라벨(클래스) 종류
        RNG rng(42);

        NeuralNetwork net;
        net.layers.emplace_back(std::make_unique<Dense>(input_dim, 32, std::make_unique<ReLU>(), rng));
        net.layers.emplace_back(std::make_unique<Dense>(32, 16, std::make_unique<ReLU>(), rng));
        net.layers.emplace_back(std::make_unique<Dense>(16, num_classes, std::make_unique<Identity>(), rng)); // logits

        std::cout << "매개변수: " << net.params() << "\n";

        // 2) 테스트용 데이터셋 생성
        Matrix X;
        std::vector<int> y;
        make_synthetic_dataset(X, y, /*per_class=*/40, /*seed=*/2025);

        // 3) 하이퍼파라미터 설정, 학습
        CrossEntropyWithLogits celoss;
        SGDConfig cfg;
        cfg.lr = 0.1;
        cfg.epochs = 30;
        cfg.batch_size = 32;
        cfg.weight_decay = 1e-4;
        auto hist = fit(net, celoss, X, y, cfg);

        // 4) 학습 성적 평가
        Matrix logits = net.forward(X);
        double acc = accuracy(logits, y);
        std::cout << "최종 학습 정확도: " << std::fixed << std::setprecision(4) << acc << "\n";

        // 5) 8x8 패턴 입력 후 결과 출력
        auto ex = flatten8x8(pattern_x()); // pattern_plus, pattern_x, pattern_box, pattern_diag 중 택1
        add_noise(ex, 0.1, rng);           // 노이즈 적용

        // 생성된 패턴 보여주기
        std::cout << "\n 생성된 입력 데이터 \n";
        for (int i = 0; i < 8; i++)
        {
            for (int j = 0; j < 8; j++)
            {
                double v = ex[j * 8 + i];
                int idx = static_cast<int>(v * (shades.size() - 1));
                if (idx < 0)
                    idx = 0;
                if (idx >= (int)shades.size())
                    idx = shades.size() - 1;
                char c = shades[idx];
                std::cout << c << c; // 모노스페이스 문자가 얇아서 두번 출력
            }
            std::cout << "\n";
        }

        std::cout << "\n";

        Matrix X1(1, 64);
        for (size_t j = 0; j < 64; ++j)
            X1(0, j) = ex[j];
        Matrix out = net.forward(X1);
        size_t pred = argmax_row(out, 0);
        std::cout << "예측: 클래스 " << pred << " (0:+, 1:X, 2:ㅁ, 3:\\)\n";

        return 0;
    }
    catch (const std::exception &e)
    {
        std::cerr << "오류: " << e.what() << "\n";
        return 1;
    }
}
