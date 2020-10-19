function first_uip = get_first_uip(obj)
% https://www.mathworks.com/matlabcentral/answers/458153-how-to-find-all-possible-path-between-2-nodes
%g: a DAG created with the digraph function
%s: start node
%e: end node
%eg:
%edges = [1,2;1,5;2,3;2,3;2,14;2,18;3,16;5,6;5,14;5,15];
%G = digraph(edges(:, 1), edges(:, 2));
% = 1;
% = 14;
%get all paths
decision_node = obj.latest_decision;
conflict_node = numel(obj.variable_values) + 1;
allpaths = get_paths(obj);
%only keep those paths that link s and e and only that part of the path between s and e (or e and s)
keep = false(size(allpaths));
for pidx = 1:numel(allpaths)
    [found, where] = ismember([decision_node, conflict_node], allpaths{pidx});
    if all(found)
        keep(pidx) = true;
        allpaths{pidx} = allpaths{pidx}(min(where):max(where)); %only keep part of the path between the two node
    end
end
selected_paths = allpaths(keep);
%after pruning the path, we may have duplicates that need removing
%this part left as 'an exercice to the reader'

% To get the first UIP, we need to find which nodes exist on
% ALL paths between decision_node and conflict_node
potential_nodes_on_all_paths = selected_paths{1};
% Remove the conflict node from the potential nodes
potential_nodes_on_all_paths = setdiff(potential_nodes_on_all_paths, conflict_node);
for path_counter = 2:numel(selected_paths)
    potential_nodes_on_all_paths = intersect(potential_nodes_on_all_paths, selected_paths{path_counter});
    if isempty(potential_nodes_on_all_paths)
        break
    end
end

% We now have a list of all nodes that show up on EVERY path
% between the decision node and the conflict node
% We find which one is closest to the decision node, and then
% return that one as the first UIP.
shortest_distance_to_conflict = Inf;
for node_counter = 1:numel(potential_nodes_on_all_paths)
    this_node = potential_nodes_on_all_paths(node_counter);
    path_to_conflict = shortestpath(obj.implication_graph, ...
        this_node, conflict_node);
    this_distance = numel(path_to_conflict);
    if this_distance < shortest_distance_to_conflict
        shortest_distance_to_conflict = this_distance;
        first_uip = this_node;
    end
end

end

function paths = get_paths(obj)
% https://www.mathworks.com/matlabcentral/answers/417396-calculating-all-paths-from-a-given-node-in-a-digraph#answer_335365
% Return all paths from a DAG.
%the function will error in toposort if the graph is not a DAG
g = obj.implication_graph;
paths = {};     %path computed so far
endnodes = [];  %current end node of each path for easier tracking
for nid = toposort(g)    %iterate over all nodes
    if indegree(g, nid) == 0    %node is a root, simply add it for now
        paths = [paths; nid]; %#ok<AGROW>
        endnodes = [endnodes; nid]; %#ok<AGROW>
    end
    %find successors of current node and replace all paths that end with the current node with cartesian product of paths and successors
    toreplace = endnodes == nid;    %all paths that need to be edited
    s = successors(g, nid);
    if ~isempty(s)
        [p, tails] = ndgrid(paths(toreplace), s);  %cartesian product
        paths = [cellfun(@(p, t) [p, t], p(:), num2cell(tails(:)), 'UniformOutput', false);  %append paths and successors
            paths(~toreplace)];
        endnodes = [tails(:); endnodes(~toreplace)];
    end
end
end