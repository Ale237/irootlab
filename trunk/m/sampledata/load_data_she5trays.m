%>@file
%>@ingroup demo
%>@brief Loads sample data she5trays.mat

function ds = load_data_she5trays()

o = dataio_mat();
o.filename = fullfile(get_rootdir(), 'sampledata', 'she5trays.mat');
ds = o.load();