%> UNDERSEL for FE pca and Classifier dist
classdef goer_undersel__pca__dist < goer_1i
    methods
        %> Constructor
        function o = setup(o)

            o.classname = 'undersel_dist';
        end;
        

        function d = customize_session(o, d)
            % Make your experiments here
        end;
    end;
end