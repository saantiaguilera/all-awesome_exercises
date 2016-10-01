# Credits to jordo45 ! Check him on -> https://www.reddit.com/user/jordo45

using Images

function f(z,f1,f2)
    return z * z - f1 - f2 * 1.0im
end

idx = 0

for iter = linspace(1.0*0.221,1.5*0.221,200)

    I = zeros(400,500)

    rows = size(I,1)
    cols = size(I,2)

    th = 2
    max_iters = 512

    for i = 1:rows
        ii = (i - rows/2)/(rows/2)
        for j = 1:cols
            jj = (j - cols/2)/(cols/2)
            z = ii + jj * 1.0im
            num_iters = 0

            while abs(z) < th && num_iters < max_iters
                z = f(z,iter,0.713)
                num_iters += 1
            end
            I[i,j] = num_iters

        end
    end

    Images.save(string(lpad(idx,4,0),".png"),sc(I))
    idx += 1
end