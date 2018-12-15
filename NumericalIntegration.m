classdef NumericalIntegration

    % Constructor
    methods
        function this = NumericalIntegration ()
            p = 2; % level of accuracy
            a = 1; % interval start
            b = 3; % interval end
            % N = [10, 20, 40, 80];
            N = [4, 8, 16, 32];
            f = @(x) 1./x;

            this.Solve(p, a, b, N, f);
        end
    end

    % Public methods
    methods
        function Solve (this, p, a, b, N, f)
            disp(' ');
            disp('--------------------------------------');
            disp('--------------- PRECISE --------------');
            disp('--------------------------------------');
            I = integral(f, a, b);
            disp(num2str(I));
            
            disp(' ');
            disp('--------------------------------------');
            disp('-------------- TRAPEZIAN -------------');
            disp('--------------------------------------');
            for i = 1 : length(N)
                S_N = this.GetTrapezoid(a, b, N(i), f);
                S_N2 = this.GetTrapezoid(a, b, N(i) / 2, f);
                runge = abs(S_N - S_N2) / (2^p - 1);
                error = abs(I - S_N);

                this.PrintStepResults(N(i), S_N, error, runge);                    
            end

            disp(' ');
            disp('--------------------------------------');
            disp('--------------- GAUSSIAN -------------');
            disp('--------------------------------------');
            for i = 1 : length(N)
                S_N = this.GetGaussian(a, b, N(i), f);
                S_N2 = this.GetTrapezoid(a, b, N(i) / 2, f);
                runge = abs(S_N - S_N2) / (2^p - 1);
                error = abs(I - S_N);

                this.PrintStepResults(N(i), S_N, error, runge);
            end
        end
    end

    % Private methods
    methods (Access = private)
        function res = GetTrapezoid (this, a, b, N, f)
            step = (b - a) / N;
            range = a : step : b;

            total = 0;
            for i = 1 : length(range) - 1
                h1 = f(range(i));
                h2 = f(range(i + 1));
                total = total + (h1 + h2) * 0.5 * step;
            end

            res = total;
        end

        function res = GetGaussian (this, a, b, N, f)
            step = (b - a) / N;
            range = a : step : b;

            total = 0;
            for i = 1 : length(range) - 1
                x = range(i) + range(i + 1);
                total = total + f(x / 2) * step;
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