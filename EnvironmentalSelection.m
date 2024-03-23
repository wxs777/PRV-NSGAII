function [Population,FrontNo,ranks] = EnvironmentalSelection(OffSpring,W,N)
    B = pdist2(W,W);
    [~,B] = sort(B,2);
    if ceil(N*0.01) == 1
        B = B(:,1:2);
    else
        B = B(:,1:ceil(N*0.01));
    end
    
    PopObj = OffSpring.objs;
    PopObj1 = OffSpring.objs;
    Fmin   = min(PopObj,[],1);
    Fmax   = max(PopObj,[],1);
    PopObj = (PopObj-repmat(Fmin,size(PopObj,1),1))./repmat(Fmax-Fmin,size(PopObj,1),1);
    [~,M] = size(PopObj);
   for i = 1 : size(PopObj1,1)
        for j = 1 : size(PopObj1,2)
             [tempranks,index]=sort(PopObj1(:,j));
             ranks(i,j)=find(index==i);
        end
    end
    ranks=sum(ranks,2);
    normP   = sqrt(sum(PopObj.^2,2));
    Cosine  = 1 - pdist2(PopObj,W,'cosine');
    d1      = repmat(normP,1,size(W,1)).*Cosine;
    d2      = repmat(normP,1,size(W,1)).*sqrt(1-Cosine.^2);
    d3      = ones(size(OffSpring,2),1);
    [d2,RP] = min(d2,[],2);
    d1      = d1((1:length(RP))'+(RP-1)*length(RP));
    
    ND              = find(NDSort(PopObj,1)==1);
    [~,Extreme]     = max(PopObj(ND,:),[],1);
    d1(ND(Extreme)) = 0;
    d2(ND(Extreme)) = 0;
    ranks(ND(Extreme)) = 0;
    for i = 1 : size(W,1)
        tempobj = PopObj(find(RP == i),:);
         [~,rank]=sort(tempobj,1);
         if ~isempty(find(RP == i))
             d3(find(RP == i)) = sum(rank,2);
         end
    end
    
    [FrontNo,MaxFNo] = SPDSort(PopObj,ranks,B,d3,RP,N);
    Next = FrontNo < MaxFNo;
    Last     = find(FrontNo==MaxFNo);
    [~,Rank] = sort(d2(Last));
    Next(Last(Rank(1:N-sum(Next)))) = true;

    
    %% Population for next generation
    Population = OffSpring(Next);
    FrontNo    = FrontNo(Next);
    ranks      = ranks(Next);
end
