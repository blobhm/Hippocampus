function r = plus(p,q,varargin)
%@dirfiles/plus Overloaded plus function for dirfiles objects.
%   R = plus(P,Q) combines dirfiles objects P and Q and returns the
%   dirfiles object R.

% get name of class
classname = mfilename('class');

% check if first input is the right kind of object
if(~isa(p,classname))
	% check if second input is the right kind of object
	if(~isa(q,classname))
		% both inputs are not the right kind of object so create empty
		% object and return it
		r = feval(classname);
	else
		% second input is the right kind of object so return that
		r = q;
	end
else
	if(~isa(q,classname))
		% p is the right kind of object but q is not so just return p
		r = p;
    elseif(isempty(p))
        % p is right object but is empty so return q, which should be
        % right object
        r = q;
    elseif(isempty(q))
        % p are q are both right objects but q is empty while p is not
        % so return p
        r = p;
	else
		% both p and q are the right kind of objects so add them 
		% together
		% assign p to r so that we can be sure we are returning the right
		% object
		r = p;
		% useful fields for most objects
		r.data.numSets = p.data.numSets + q.data.numSets;

		% object specific fields
% 		r.data.detailed_fr = [p.data.detailed_fr; q.data.detailed_fr];
        r.data.linear_map = [p.data.linear_map; q.data.linear_map];
%         r.data.maps_adsmooth = [p.data.maps_adsmooth; q.data.maps_adsmooth];
        r.data.SIC = [p.data.SIC; q.data.SIC];
        r.data.ISE = [p.data.ISE; q.data.ISE];
        r.data.SICsh = [p.data.SICsh; q.data.SICsh];
        r.data.ISEsh = [p.data.ISEsh; q.data.ISEsh];
        r.data.SIC1 = [p.data.SIC1; q.data.SIC1];
        r.data.SIC2 = [p.data.SIC2; q.data.SIC2];
        r.data.ISE1 = [p.data.ISE1; q.data.ISE1];
        r.data.ISE2 = [p.data.ISE2; q.data.ISE2];
        
        r.data.origin = [p.data.origin; q.data.origin];
			
		% add nptdata objects as well
		r.nptdata = plus(p.nptdata,q.nptdata);
	end
end
