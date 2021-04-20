% Takes in an array of points in the complex plane
% Returns the length of the perimeter of the shape created from the points
function f = ComputePerimeter(points)

	totalLength = 0;
	for i=2:size(points)

		dx = real(points(i)) - real(points(i-1));
		dy = imag(points(i)) - imag(points(i-1));

		totalLength = totalLength + sqrt(dx*dx + dy*dy);

	end
	
	f = totalLength;
end