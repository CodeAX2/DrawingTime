% numConstants is the number of constants to expand out for the fourier transform
% numPartitions is the number of partitions used on the integrals for calculating the constants
% timeSteps is the number of timesetps used when drawing the image
function FourierImage(inputMatrixFile, numConstants, numPartitions, timeSteps)

	pointsMatrix = dlmread(inputMatrixFile); % Read in the matrix

	% Convert to a list of complex numbers
	pointsComplex = zeros(size(pointsMatrix, 1), 1);
	for i = 1:size(pointsMatrix, 1)
		pointsComplex(i) = pointsMatrix(i,1) + pointsMatrix(i,2) * 1i;
	end

	% Calculate the length of the perimeter of the shape
	totalLength = ComputePerimeter(pointsComplex);

	% Calculate the constants from fourier transform
	c = zeros(numConstants, 1);
	for i = -numConstants/2 + 1:numConstants/2

		for t = 0:1/numPartitions:1
			% Calculate the integral
			c(i + numConstants/2) = ...
				c(i + numConstants/2) + ...
				exp(-2 * pi * 1i * i * t) * ...
				InterpolatePath(pointsComplex, totalLength, t) * ...
				1/numPartitions;
		end

	end

	% Calculate the points from t=0 to t=1 using fourier
    % Not including t=0 and t=1 since edge cases often break
    % the simulation
	fourierPoints = zeros(timeSteps-1, 1);
	for t = 1:timeSteps-1
        for i = -numConstants/2 + 1:numConstants/2
            fourierPoints(t) = fourierPoints(t) + c(i + numConstants/2) * exp(i * 2 * pi * 1i * t/timeSteps);
        end
    end

	% We now have our constants, so draw the shape
	% Convert back to vector for easy drawing
	fourierPointsVectored = [real(fourierPoints), imag(fourierPoints)];

	% Draw the figure
	figure;
	xlim([-1 1]);
	ylim([-1 1]);
	hold on;
	comet(fourierPointsVectored(:,1),fourierPointsVectored(:,2));

end
