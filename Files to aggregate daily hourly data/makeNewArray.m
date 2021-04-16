function newArray = makeNewArray(newArray,value2append, arrayTyp)
%  
%
%Created by Allison Stokoe 4/13/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch arrayTyp
    case 'addifEmpty'
        if isempty(newArray)
          newArray = [newArray,value2append];
        else
           %do nothing
        end
    case 'checkRepeats'
        if contains(newArray,value2append)
            %don't append
        else
            newArray = [newArray,value2append];
        end
    case 'checkEmpty'
        if isempty(newArray)
           newArray = value2append;
        else
           newArray = [newArray,value2append];
        end
    case 'append2column'
        newArray = [newArray;value2append];
    case 'appendNewColumn'
        newArray = [newArray,value2append];
end
end

