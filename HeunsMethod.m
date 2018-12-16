classdef HeunsMethod

    % Constructor
    methods
        function this = HeunsMethod ()
            f = @(x,u) -u + sin(x);
            h = [0.1, 0.05, 0.025, 0.0125];
            colours = ['k', 'g', 'b', 'r'];
            p = 2;
            U = 1;

            this.Solve(f, h, U, p, colours);
        end
    end

    % Public methods
    methods
        function Solve (this, f, h, U, p, colours)
            hold on
            for i = 1 : length(h)
                hi = h(i);
                Ni = 1 / hi;
                U0 = [U];
                [x, y] = this.GetHeuns(Ni, hi, U0, f, true);

                % Calculate the same thing but twice the step for error calculations
                hi = h(i) * 2;
                Ni = 1 / hi;
                [x1, y1] = this.GetHeuns(Ni, hi, U0, f, false);

                % Calculate the error
                runge = abs(y(end) - y1(end)) / 2.^p - 1;
                disp(['i: ' num2str(i) '      runge: ' num2str(runge)]);

                plot(x, y, colours(i));
            end
            hold off
        end
    end

    % Private methods
    methods (Access = private)
        function [x, U] = GetHeuns (this, N, h, U0, f, print)
            if print
                disp(' ');
                disp('-------------------------------------------------------');
                disp(['------------------- STEP = ' num2str(h) ' ---------------------']);
                disp('-------------------------------------------------------');
            end

            U = [U0];
            for i = 0 : N - 1
                x(i + 1) = i * h;

                x_i = x(i + 1);
                U_i = U(i + 1);
                k1 = f(x_i, U_i);
                k2 = f(x_i + h, U_i + h * k1);
                U(i + 2) = U_i + h/2 * (k1 + k2);

                if print this.PrintStepResults(i + 1, x_i, U_i); end
            end

            x(N + 1) = N * h;
            if print this.PrintStepResults(N + 1, x(N + 1), U(N + 1)); end
        end

        function res = PadString (this, message, width)
			differ = width - length(message);
			for i = 1 : differ
				message = [message, ' '];
			end
			res = message;
		end

		function PrintStepResults (this, i, x_i, U_i)
			message = [];

			mock = ['i: ' num2str(i)];
			note = this.PadString(mock, 10);
			message = [message, note];

            mock = ['X_i: ' num2str(x_i)];
			note = this.PadString(mock, 15);
			message = [message, note];

			mock = ['U_i: ' num2str(U_i)];
			note = this.PadString(mock, 20);
			message = [message, note];

			disp(message);
		end
    end

end