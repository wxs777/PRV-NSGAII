classdef RPVNSGAII < ALGORITHM
    methods
        function main(Algorithm,Problem)
            %% Generate the reference points and random population
            [RPSet,Problem.N] = UniformPoint(Problem.N,Problem.M);
            Population        = Problem.Initialization();
            [~,FrontNo,d2]    = EnvironmentalSelection(Population,RPSet,Problem.N);

            %% Optimization
            while Algorithm.NotTerminated(Population) 
                MatingPool = TournamentSelection(2,Problem.N,FrontNo,d2);
                Offspring  = OperatorGA(Population(MatingPool));
                [Population,FrontNo,d2] = EnvironmentalSelection([Population,Offspring],RPSet,Problem.N);
            end
        end
    end
end