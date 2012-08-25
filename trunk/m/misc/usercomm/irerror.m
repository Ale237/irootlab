%>@ingroup usercomm
%>@file
%>@brief Verboses and throws an Exception
%>
%> Exceptions raised by this function represent bad usage of IRoot, and not necessarily a bug
function irerror(s)
irverbose(['{ERROR}', s]);
% dbstack();
s = strrep(s, '\', '\\'); % I think that MATLAB uses s as first argument o a printf()-like function, which messes the message if it has backslashes!
throw(MException('IRoot:bad', s));