%> Used to calculate (number of factors)x(performance) curves
%> 
%> This class uses a reptt_sgs and a fcon block (@ref fcon_mold) that has the @c no_factors property.
%> 
%> It populates the reptt_sgs block with many replications of @c fcon_mold, with increasing values in the @c no_factors property
%> 
%> It has a @ref extract_reptt_sgs function for the GUI. However, a property box is not implemented at the moment.
%>
%> Please note that a Standardization block will be automatically inserted between the Feature Extraction block and the Classifier.
%> 
%> @sa reptt_sgs.m
classdef factorscurve < as
    properties
        fcon_mold;
        %> The classifier
        clssr;
        %> Maximum number of factors. Defaults to the number of features in the dataset
        no_factors_max = [];
        
        %> SGS object. It is optional if @ref data has more than 1 element. If @ref cube is passed, this property is ignored altogether.
        sgs;
        %> =[]. See @reptt
        postpr_test;
        %> =decider(). See @ref reptt
        postpr_est = decider();
        
        %> Mold fcon block with the no_factors property
        %> = 0. Whether to parallelize the calculation
        flag_parallel = 0;
    end;
    
    methods
        function o = factorscurve()
            o.classtitle = '(#factors)x(performance) curve';
            o.moreactions = [o.moreactions, {'go', 'extract_reptt'}];
        end;

        function u = create_cube(o, data)
            l1 = estlog_classxclass();
            l1.estlabels = data.classlabels;
            l1.testlabels = data.classlabels;
            l1.title = 'rates';

            u = reptt_blockcube();
            u.log_mold = {l1};
            if numel(data) == 1
                u.sgs = def_sgs(o.sgs);
            end;
            u.flag_parallel = o.flag_parallel;

            u.postpr_test = o.postpr_test;
            u.postpr_est = o.postpr_est;
            u.data = data;
        end;
    end;
    
    methods(Access=protected)
        %> @return irdata object
        function [o, out] = go(o, data)
            if isempty(o.no_factors_max)
                neff = data.nf;
            else
                neff = min(o.no_factors_max, data.nf);
            end;
            ss = pre_std(); % Standardization block
            bb = cell(1, neff); % Cell array of blocks
            cl = def_clssr(o.clssr);
            for i = 1:neff
                btemp = o.fcon_mold;
                btemp.no_factors = i;
                
                blk = block_cascade();
                blk.title = sprintf('%d factor%s', i, iif(i == 1, '', 's'));
                blk.blocks = {btemp, ss, cl};
                
                bb{i} = blk;
            end;
            
            u = o.create_cube(data);
            u.block_mold = bb;
            log = u.go();
            
            sov = sovalues();
            sov = sov.read_log_cube(log);
            
            out = irdata();
            out.xname = 'Number of factors';
            out.xunit = '';
            out.yname = 'Classification rate';
            out.yunit = '%';
            out.X = permute(sov.get_Y('rates'), [3, 2, 1]);
            out.classes = zeros(size(out.X, 1), 1);
            out.classlabels = {o.fcon_mold.get_description()};
            out = out.assert_fix();
        end;
    end;
end