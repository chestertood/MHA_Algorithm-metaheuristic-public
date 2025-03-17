function optimization_functions()
    arr = [0.1, 0.2, 0.3];
    dim = numel(arr);

    funcs = {
        @() Sphere(arr, 2), ...
        @() Ackley(arr), ...
        @() AckleyTest(arr), ...
        @() Rosenbrock(arr), ...
        @() Fletcher(arr, dim), ...
        @() Griewank(arr), ...
        @() Penalty2(arr, 5, 100, 4), ...
        @() Quartic(arr), ...
        @() Rastrigin(arr), ...
        @() SchwefelDouble(arr), ...
        @() SchwefelMax(arr), ...
        @() SchwefelAbs(arr), ...
        @() SchwefelSin(arr), ...
        @() Stairs(arr), ...
        @() AbsFunc(arr), ...
        @() Michalewicz(arr, 10), ...
        @() Scheffer(arr), ...
        @() Eggholder(arr), ...
        @() Weierstrass(arr, 0.5, 3, 20)
    };

    for i = 1:length(funcs)
        disp(funcs{i}());
    end
end

function val = Sphere(vec, degree)
    val = sum(vec .^ degree);
end

function val = Ackley(vec)
    bias = 20 + exp(1);
    s1 = mean(vec .^ 2);
    s2 = mean(cos(2 * pi * vec));
    val = bias - 20 * exp(-0.2 * sqrt(s1)) - exp(s2);
end

function val = AckleyTest(vec)
    expConst = exp(-0.2);
    val = 0;
    for i = 1:(numel(vec)-1)
        val = val + 3 * (cos(2 * vec(i)) + sin(2 * vec(i+1))) + ...
              expConst * sqrt(vec(i)^2 + vec(i+1)^2);
    end
end

function val = Rosenbrock(vec)
    val = 0;
    for i = 1:(numel(vec)-1)
        val = val + 100 * (vec(i+1) - vec(i)^2)^2 + (vec(i) - 1)^2;
    end
end

function val = Fletcher(vec, dim)
    rng(1); % Seed for reproducibility
    a = -100 + (100 - (-100)) * rand(dim, dim);
    b = -100 + (100 - (-100)) * rand(dim, dim);
    A = sum(a .* sin(vec') + b .* cos(vec'), 2);
    B = sum(a .* sin(vec') + b .* cos(vec'), 2);
    val = sum((A - B).^2);
end

function val = Griewank(vec)
    s = sum(vec .^ 2) / 4000;
    p = prod(cos(vec ./ sqrt(1:numel(vec))));
    val = 1 + s - p;
end

function val = Penalty2(vec, a, k, m)
    u = sum((vec(vec > a) - a).^m) + sum((-vec(vec < -a) - a).^m);
    s1 = 10 * sin(3 * pi * vec(1))^2 + (vec(end) - 1)^2 * (1 + sin(2 * pi * vec(end)^2));
    s2 = 0;
    for i = 1:(numel(vec)-1)
        s2 = s2 + (vec(i) - 1)^2 * (1 + sin(3 * pi * vec(i+1)^2));
    end
    val = k * u + 0.1 * (s1 + s2);
end

function val = Quartic(vec)
    val = sum((1:numel(vec)) .* vec.^4);
end

function val = Rastrigin(vec)
    val = 10 * numel(vec) + sum(vec.^2 - 10 * cos(2 * pi * vec));
end

function val = SchwefelDouble(vec)
    cs = cumsum(vec);
    val = sum(cs.^2);
end

function val = SchwefelMax(vec)
    val = max(abs(vec));
end

function val = SchwefelAbs(vec)
    val = sum(abs(vec)) + prod(abs(vec));
end

function val = SchwefelSin(vec)
    val = -sum(vec .* sin(sqrt(abs(vec))));
end

function val = Stairs(vec)
    val = sum(floor(vec + 0.5).^2);
end

function val = AbsFunc(vec)
    val = sum(abs(vec));
end

function val = Michalewicz(vec, m)
    val = -sum(sin(vec) .* (sin((1:numel(vec)) .* vec.^2 / pi)).^(2 * m));
end

function val = Scheffer(vec)
    val = 0.5;
    for i = 1:(numel(vec)-1)
        s = sin(vec(i)^2 - vec(i+1)^2)^2 - 0.5;
        d = (1 + 0.001 * (vec(i)^2 + vec(i+1)^2))^2;
        val = val + s / d;
    end
end

function val = Eggholder(vec)
    val = 0;
    for i = 1:(numel(vec)-1)
        val = val - ((vec(i+1) + 47) * sin(sqrt(abs(vec(i+1) + vec(i)/2 + 47))) + ...
                     vec(i) * sin(sqrt(abs(vec(i) - vec(i+1) - 47))));
    end
end

function val = Weierstrass(vec, a, b, kmax)
    ak = a.^(0:kmax);
    bk = b.^(0:kmax);
    bias = -numel(vec) * sum(ak .* cos(pi * bk));
    val = bias;
    for i = 1:numel(vec)
        val = val + sum(ak .* cos(2 * pi * bk * (vec(i) + 0.5)));
    end
end
