function [FrontNo,MaxFNo] = SPDSort(PopObj,d1,d2,d3,RP,nSort)
     Density=histc(RP,1:nSort);
     aveDensity = sum(Density)/length(Density);
    [N,M]   = size(PopObj);
    FrontNo = inf(1,N);
    MaxFNo  = 0;
    while sum(FrontNo<inf) < min(nSort,N)
        MaxFNo = MaxFNo + 1;
        Sorted = FrontNo ~= inf;
        D      = Sorted;
        for i = 1 : N
            if ~D(i)
                for j = i+1 : N
                    if ~D(j)
                        domi = 0;
                        for m = 1 : M
                            if PopObj(i,m) < PopObj(j,m)
                                if domi == -1
                                    domi = 0;
                                    break;
                                else
                                    domi = 1;
                                end
                            elseif PopObj(i,m) > PopObj(j,m)
                                if domi == 1
                                    domi = 0;
                                    break;
                                else
                                    domi = -1;
                                end
                            end
                        end
                        if domi == 0 && RP(i)==RP(j)
                            if d1(i) < d1(j)
                            	domi = 1;
                            elseif d1(i) > d1(j)
                            	domi = -1;
                            end
                        elseif domi == 0 && RP(i)~=RP(j)
                            if d1(i) < d1(j) &&  Density(RP(i)) <  Density(RP(j)) && Density(RP(i)) > aveDensity && Density(RP(j)) > aveDensity && ismember(RP(j),d2(RP(i),:))
                            	domi = 1;
                            end
                        end
                        if domi == 1
                            D(j) = true;
                        elseif domi == -1
                            D(i) = true;
                            break;
                        end
                    end
                end
                if ~D(i)
                    FrontNo(i) = MaxFNo;
                end
            end
        end
    end
end