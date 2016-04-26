//matrix_add.cu
//这个文件不推荐直接拷贝，最好一行一行地抄下来
#include <stdio.h>

#define N 32  //这里定义了矩阵的阶级，这里用一个32x32的方形矩阵做例子
//想要自己Debug的时候，遇到问题，可以先把N的值设置小一些，比如4

/*
 * 本次的核函数，三个参数分别是两个NxN的输入矩阵和一个NxN的输出矩阵
 */
__global__ void calculate_object(const double x[][N],
    const double y[][N],
    const double z[][N],
    const double v[][N],
    const double a[][N],
    const double *interval) {
    int idx = threadIdx.x;
    int idy = threadIdx.y;
    double v_delt =  a[idx][idy] * (*interval);
    double v_new = v[idx][idy] + v_delt;
    double s_new = v[idx][idy] * (*interval) + a[idx][idy]*(*interval)*(*interval) / 2.0;
}

int main(void) {

  double *h_x, *h_y, *h_z, *h_v, *h_a;
  double *dev_x, *dev_y, *dev_z, *dev_v, *dev_a;
  double *h_interval;
  double *dev_interval;

  //这里把一个block的里面的线程排列定义成二维的，这样会有两个维度的索引值，x和y
  dim3 threads_in_block (N, N);
  //err这个值是用来检查cuda的函数是否正常运行的
  cudaError_t err = cudaSuccess;

  h_x = (double *)malloc(sizeof(double) * N * N);
  h_y = (double *)malloc(sizeof(double) * N * N);
  h_z = (double *)malloc(sizeof(double) * N * N);
  h_v = (double *)malloc(sizeof(double) * N * N);
  h_a = (double *)malloc(sizeof(double) * N * N);

  h_interval = (double*)malloc(sizeof(double));
  
  if (h_x == NULL || h_y == NULL || h_z == NULL
      || h_v == NULL || h_a == NULL) {
    fprintf(stderr, "Malloc() failed.\n");
    return -1;
  }

  err = cudaMalloc((void **)&dev_x, sizeof(double) * N * N);
  if (err != cudaSuccess) {
    fprintf(stderr, "cudaMalloc() failed.\n");
    return -1;

  }
  err = cudaMalloc((void **)&dev_y, sizeof(double) * N * N);
  if (err != cudaSuccess) {
    fprintf(stderr, "cudaMalloc() failed.\n");
    return -1;
  }

  err = cudaMalloc((void **)&dev_z, sizeof(double) * N * N);
  if (err != cudaSuccess) {
    fprintf(stderr, "cudaMalloc() failed.\n");
    return -1;
  }

  err = cudaMalloc((void **)&dev_v, sizeof(double) * N * N);
  if (err != cudaSuccess) {
    fprintf(stderr, "cudaMalloc() failed.\n");
    return -1;
  }

  err = cudaMalloc((void **)&dev_a, sizeof(double) * N * N);
  if (err != cudaSuccess) {
    fprintf(stderr, "cudaMalloc() failed.\n");
    return -1;
  }

  err = cudaMalloc((void **)&dev_interval, sizeof(double));
  if (err != cudaSuccess) {
    fprintf(stderr, "cudaMalloc() failed.\n");
    return -1;
  }

  for (int i = 0; i < N * N; i++) {
    h_x[i] = 2 * i + 1.0;
    h_y[i] = -1 * i + 5.0;
    h_z[i] = -1 * i + 3.0;
    h_v[i] = -1 * i + 4.0;
    h_a[i] = -1 * i + 8.0;
  }
  h_interval = 3.0;

  err = cudaMemcpy(dev_x, h_x, sizeof(double) * N * N, cudaMemcpyHostToDevice);
  if (err != cudaSuccess) {
    fprintf(stderr, "cudaMemcpy() failed.\n");
    return -1;
  }

  err = cudaMemcpy(dev_y, h_y, sizeof(double) * N * N, cudaMemcpyHostToDevice);
  if (err != cudaSuccess) {
    fprintf(stderr, "cudaMemcpy() failed.\n");
    return -1;
  }

  err = cudaMemcpy(dev_z, h_z, sizeof(double) * N * N, cudaMemcpyHostToDevice);
  if (err != cudaSuccess) {
    fprintf(stderr, "cudaMemcpy() failed.\n");
    return -1;
  }
  err = cudaMemcpy(dev_v, h_v, sizeof(double) * N * N, cudaMemcpyHostToDevice);
  if (err != cudaSuccess) {
    fprintf(stderr, "cudaMemcpy() failed.\n");
    return -1;
  }
  err = cudaMemcpy(dev_a, h_a, sizeof(double) * N * N, cudaMemcpyHostToDevice);
  if (err != cudaSuccess) {
    fprintf(stderr, "cudaMemcpy() failed.\n");
    return -1;
  }

  err = cudaMemcpy(dev_interval, h_interval, sizeof(double), cudaMemcpyHostToDevice);
  if (err != cudaSuccess) {
    fprintf(stderr, "cudaMemcpy() failed.\n");
    return -1;
  }

  calculate_object<<<1, threads_in_block>>>((double (*)[N])dev_x, (double (*)[N])dev_y, (double (*)[N])dev_z,
      (double (*)[N])dev_v, (double (*)[N])dev_a, (double*)interval);

  /*err = cudaMemcpy(h_c, dev_c, sizeof(double) * N * N, cudaMemcpyDeviceToHost);
  if (err != cudaSuccess) {
    fprintf(stderr, "cudaMemcpy() failed.\n");
    return -1;
  }

  for (int i = 0; i < N * N; i++) {
    if (h_a[i] + h_b[i] != h_c[i]) {
      fprintf(stderr, "a[%d]%d + b[%d]%d != c[%d]%d.\n", i, h_a[i], i, h_b[i], i, h_c[i]);
      return -1;
    }
  }*/

  printf("done.\n");
  return 0;

}

