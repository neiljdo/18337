@time sleep(2)

@time @sync @time for i in 1:10
    @async sleep(2)
end

# @time begin
    # a = Vector{Any}(undef, nworkers())
    # @sync for (idx, pid) in enumerate(workers())
        # @async a[idx] = remotecall_fetch(pid, sleep, 2)
    # end
# end


using StaticArrays, BenchmarkTools
function lorenz(u,p)
  α,σ,ρ,β = p
  @inbounds begin
    du1 = u[1] + α*(σ*(u[2]-u[1]))
    du2 = u[2] + α*(u[1]*(ρ-u[3]) - u[2])
    du3 = u[3] + α*(u[1]*u[2] - β*u[3])
  end
  @SVector [du1,du2,du3]
end
function solve_system_save!(u,f,u0,p,n)
  @inbounds u[1] = u0
  @inbounds for i in 1:length(u)-1
    u[i+1] = f(u[i],p)
  end
  u
end
p = (0.02,10.0,28.0,8/3)
u = Vector{typeof(@SVector([1.0,0.0,0.0]))}(undef,1000)
@btime solve_system_save!(u,lorenz,@SVector([1.0,0.0,0.0]),p,1000)
