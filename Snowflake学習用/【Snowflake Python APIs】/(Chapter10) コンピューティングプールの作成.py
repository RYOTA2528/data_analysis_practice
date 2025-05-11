# 1 コンピューティングプールを定義
new_compute_pool_def = ComputePool(
    name="MyComputePool",
    instance_family="CPU_X64_XS",
    min_nodes=1,
    max_nodes=2,
)

# 2 コンピューティングプールの作成
new_compute_pool = root.compute_pools.create(new_compute_pool_def)