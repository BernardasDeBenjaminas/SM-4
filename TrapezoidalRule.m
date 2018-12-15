classdef TrapezoidalRule

    % Constructor
    methods
        function this = TrapezoidalRule ()
            p = 2; % level of accuracy
            a = 1; % interval start
            b = 3; % interval end
            N = [10, 20, 40, 80];
            f = @(x) 1./x;

            this.Solve(p, a, b, N, f);
        end
    end

    % Public methods
    methods
        function Solve (this, p, a, b, N, f)
            I = integral(f, a, b);
            
            for i = 1 : length(N)
                S_N = this.GetIntegral(a, b, N(i), f);
                S_N2 = this.GetIntegral(a, b, N(i) / 2, f);
                runge = abs(S_N - S_N2) / (2^p - 1);
                error = abs(I - S_N);

                this.PrintStepResults(N(i), S_N, error, runge);                    
            end
        end
    end

    % Private methods
    methods (Access = private)
        function res = GetIntegral (this, a, b, N, f)
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

            res = total;
        end


        function res = PadString (this, message, width)
			differ = width - length(message);
			for i = 1 : differ
				message = [message, ' '];
			end
			res = message;
		end

		function PrintStepResults (this, N, S_N, error, runge)
			message = [];

			mock = ['N: ' num2str(N)];
			note = this.PadString(mock, 10);
			message = [message, note];

            mock = ['S_N: ' num2str(S_N)];
			note = this.PadString(mock, 15);
			message = [message, note];
            
            mock = ['e_N: ' num2str(error)];
			note = this.PadString(mock, 20);
			message = [message, note];

			mock = ['8_N: ' num2str(runge)];
			note = this.PadString(mock, 20);
			message = [message, note];

			disp(message);
		end
    end

end