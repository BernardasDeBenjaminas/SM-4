classdef TrapezoidalRule

    % Constructor
    methods
        function this = TrapezoidalRule ()
            a = 1; % interval start
            b = 3; % interval end
            N = 32; % spacing
            stringFunc = '1/x';

            this.Solve(a, b, N, inline(stringFunc));
        end
    end

    % Public methods
    methods
        function Solve (this, a, b, N, f)
            step = (b - a) / N;
            range = a : step : b;

            total = 0;
            for i = 1 : length(range) - 1
                h1 = f(range(i));
                h2 = f(range(i + 1));
                hDiff = abs(h1 - h2);
                % Calculate the areas
                triangle = step * hDiff / 2;
                quad = min(h1, h2) * step;
                total = total + triangle + quad;
            end

            disp('-----------------------------');
            disp(['The result: ' num2str(total)]);
        end
    end

    % Private methods
    methods (Access = private)

    end

end