% Interpolates along a path of complex numbers at a given point t in [0,1]
function f = InterpolatePath(points, totalLength,t)
	
	% Now we interpolate
	desiredDistance = t * totalLength;
	travelled = 0;
	curPointIndex = 1;
	previousPointIndex = 0;
	
	% Walk along the path until we overshoot
	while 1
		
		previousPointIndex = previousPointIndex + 1;
		curPointIndex = curPointIndex + 1;
		
		dx = real(points(curPointIndex)) - real(points(previousPointIndex));
		dy = imag(points(curPointIndex)) - imag(points(previousPointIndex));
	
		travelled = travelled + sqrt(dx*dx + dy*dy);
		
		if ~(travelled < desiredDistance)
			break;
		end
		
	end
	
	% This is the amount we overshot by
	overshootAmount = travelled - desiredDistance;
	
	% So we need to lerp from currentPoint to previousPoint by
	% the amount we overshot
	
	curPoint = [real(points(curPointIndex)), imag(points(curPointIndex))];
	prevPoint = [real(points(previousPointIndex)), imag(points(previousPointIndex))];
	
	dx = curPoint(1) - prevPoint(1);
	dy = curPoint(2) - prevPoint(2);
	
	distanceBetweenCurPrev = sqrt(dx*dx + dy*dy);
	
	ratio = overshootAmount / distanceBetweenCurPrev;
	
	finalPoint = (prevPoint - curPoint) * ratio + curPoint;
	
	% Turn the final point into a complex number
	f = finalPoint(1) + finalPoint(2) * 1i;

end