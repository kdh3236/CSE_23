import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path

base = Path("./")  # 현재 폴더 기준

pairs = [
    ("uniform_100.txt",    "gaussian_100.txt",    100),
    ("uniform_1000.txt",   "gaussian_1000.txt",   1000),
    ("uniform_10000.txt",  "gaussian_10000.txt",  10000),
    ("uniform_100000.txt", "gaussian_100000.txt", 100000),
]

a, b = -3, 4
m, s = 0.5, 1.5

for ufile, gfile, n in pairs:
    u = np.loadtxt(base / ufile)
    g = np.loadtxt(base / gfile)

    fig, axes = plt.subplots(1, 2, figsize=(12, 4))

    axes[0].hist(u, bins=100, range=(a, b), density=True,
                 color='skyblue', edgecolor='black', linewidth=0.4)
    axes[0].set_title(f"Uniform Distribution (a={a}, b={b})\n n={n}")
    axes[0].set_xlabel("Value")
    axes[0].set_ylabel("Density")

    axes[1].hist(g, bins=100, range=(m-6*s, m+6*s), density=True,
                 color='salmon', edgecolor='black', linewidth=0.4)
    axes[1].set_title(f"Gaussian Distribution (μ={m}, σ={s})\n n={n}")
    axes[1].set_xlabel("Value")
    axes[1].set_ylabel("Density")

    plt.tight_layout()
    plt.show()