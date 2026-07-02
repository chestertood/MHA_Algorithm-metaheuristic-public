# MHA — Monster Hunter Algorithm (Metaheuristic Optimization)

MATLAB implementation of the **Monster Hunter Algorithm (MHA/MHO)**, a nature-inspired metaheuristic optimizer, plus **CHEMICA** (an adaptive/causal-AI variant). Benchmarked against classic metaheuristics on standard test functions and real-world engineering design problems.

## Algorithms included

- **MHA / MHO** — Monster Hunter Algorithm (base, adaptive, and phase variants)
- **CHEMICA** — adaptive metaheuristic with causal-AI-guided search (`CHEMICA_and_causalAI.m`)
- Comparison baselines: GA, PSO, GWO, ABC, SA, WOA, PUMA

## Entry points

| File | Purpose |
|---|---|
| `MHA_version_lastest.m` | Main runner — latest MHA/CHEMICA version |
| `CHEMICA_and_causalAI.m` | Self-contained script: CHEMICA + MHO_Adaptive + GA/PSO/GWO/ABC/SA/WOA, all in one file |
| `Test_all_algorithm.m` | Run/compare all algorithms together |
| `Run_30dim_30run.m`, `Run_50dim_30run.m`, `Run_100dim_30run.m` | Batch runs across dimensions, 30 runs each |

## Benchmark problems

- `Functions.m`, `Functions_30/50/100.m`, `Functions_dim.m` — CEC-style benchmark functions F1–F23
- `Func_eng.m` — real-world engineering design problems (Pressure Vessel, Welded Beam, Cantilever Beam, Three Bar Truss, Gear Train, String Design)
- `Fluid_realworld.m`, `Power_Consumption.m`, `Realword_Boston_housing.m` — applied real-world case studies
- `CEC2017.m` — CEC2017 benchmark suite

## Usage

Open `MHA_version_lastest.m` (or `CHEMICA_and_causalAI.m`) in MATLAB, set benchmark function ID (`F1`–`F23`, or engineering problem name), set `params.MaxIt` / `params.nPop`, then run.

```matlab
F = 'F1';
[lb, ub, dim, fobj] = Functions(F);
problem.CostFunction = fobj; problem.nVar = dim;
problem.VarMin = lb; problem.VarMax = ub;
params.MaxIt = 1000; params.nPop = 50;
[BestSol, BestCost, Convergence, Log] = CHEMICA(problem, params);
```

## Results

Precomputed results/statistics saved as `.mat` (raw runs) and `.xlsx`/`.csv` (summary tables) for reference and reproducibility.

## Third-party code

`shahin1009-PathPlanning-887b67f/` — RRT/PRM path-planning reference code, included separately (see its own README for credit).

## Requirements

MATLAB (no extra toolboxes required for core algorithms; Statistics/Optimization toolbox may be needed for some real-world case studies).
