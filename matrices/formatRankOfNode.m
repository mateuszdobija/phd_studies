function [result] = formatRankOfNode(node)
%formatRankOfNodeInCaseOfZeroedElementsInVROwsOrUColumns
if nnz(node.U_columns) == 0 || nnz(node.V_rows) == 0
    result=Node;
    result.rank=0;
    [numRows,~]=size(node.U_columns);
    result.rowsWithZero = numRows;
    [~,numCols]=size(node.V_rows);
    result.columnsWithZero = numCols;
    if checkCorrectnessOfTreeStructure(result)~=0
        error('error');
    end
    
else
    result = node;
end
