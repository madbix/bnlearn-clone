
# get the root nodes of a graph.
root.nodes = function(x) {

  # check x's class.
  check.bn.or.fit(x)

  root.leaf.nodes(x, leaf = FALSE)

}#ROOT.NODES

# get the leaf nodes of a graph.
leaf.nodes = function(x) {

  # check x's class.
  check.bn.or.fit(x)

  root.leaf.nodes(x, leaf = TRUE)

}#LEAF.NODES

# check if a graph is acyclic.
acyclic = function(x, directed, debug = FALSE) {

  # check x's class.
  check.bn.or.fit(x)
  # check debug.
  check.logical(debug)

  # fitted bayesian networks are always acylic.
  if (is(x, "bn.fit"))
    return(TRUE)

  if (missing(directed)) {

    is.acyclic(x$arcs, names(x$nodes), debug = debug)

  }#THEN
  else {

    # check directed.
    check.logical(directed)

    is.acyclic.backend(arcs = x$arcs, nodes = names(x$nodes),
      directed = directed, debug = debug)

  }#ELSE

}#ACYCLIC

# check if a graph is directed.
directed = function(x) {

  # check x's class.
  check.bn.or.fit(x)

  # fitted bayesian networks are always directed.
  if (is(x, "bn.fit"))
    return(TRUE)

  is.dag(x$arcs, names(x$nodes))

}#DIRECTED

# check if there's a path between two specific nodes.
path = function(x, from, to, direct = TRUE, underlying.graph = FALSE,
    debug = FALSE) {

  # check x's class.
  check.bn.or.fit(x)
  # a valid node is needed.
  check.nodes(nodes = from, graph = x, max.nodes = 1)
  # another valid node is needed.
  check.nodes(nodes = to, graph = x, max.nodes = 1)
  # 'from' must be different from 'to'.
  if (identical(from, to))
    stop("'from' and 'to' must be different from each other.")
  # check underlying.path.
  check.logical(underlying.graph)
  # check debug.
  check.logical(debug)

  if (is(x, "bn")) {

    nodes = names(x$nodes)
    amat = arcs2amat(x$arcs, nodes)

  }#THEN
  else {

    nodes = names(x)
    amat = arcs2amat(fit2arcs(x), nodes)

  }#ELSE

  has.path(from, to, nodes = nodes, amat = amat, exclude.direct = !direct,
    underlying.graph = underlying.graph, debug = debug)

}#PATH

# return the partial node ordering implied by the graph structure.
node.ordering = function(x, debug = FALSE) {

  # check x's class.
  check.bn.or.fit(x)
  # check debug.
  check.logical(debug)
  # no model string if the graph is partially directed.
  if (is(x, "bn"))
    if (is.pdag(x$arcs, names(x$nodes)))
      stop("the graph is only partially directed.")

  schedule(x, debug = debug)

}#NODE.ORDERING

# generate a valid blacklist from a partial node ordering.
ordering2blacklist = function(nodes) {

  if (is(nodes, "bn") || is(nodes, "bn.fit")) {

    nodes = schedule(nodes)

  }#THEN

  # check the node labels.
  check.nodes(nodes, min.nodes = 3)

  tiers.backend(nodes)

}#ORDERING2BLACKLIST

tiers2blacklist = function(nodes) {

  # check the node labels.
  if (is.list(nodes)) {

    if (!all(sapply(nodes, is.character)))
      stop("node labels must be character strings.")

    check.nodes(unlist(nodes), min.nodes = 3)

  }#THEN
  else {

    check.nodes(nodes, min.nodes = 3)

  }#ELSE

  tiers.backend(nodes)

}#TIERS2BLACKLIST

# return the skeleton of a (partially) directed graph
skeleton = function(x) {

  # check x's class.
  check.bn(x)

  dag2ug.backend(x, moral = FALSE)

}#SKELETON

# return a complete orientation of a graph.
pdag2dag = function(x, ordering) {

  # check x's class.
  check.bn(x)
  # check the node ordering.
  check.nodes(ordering, graph = x, min.nodes = length(x$nodes),
    max.nodes = length(x$nodes))

  arcs = pdag2dag.backend(x$arcs, ordering)

  # update the arcs of the network.
  x$arcs = arcs
  # update the network structure.
  x$nodes = cache.structure(nodes = names(x$nodes), arcs = arcs)

  return(x)

}#PDAG2DAG

# return a partial orientation of an undirected graph (skeleton)).
skeleton2pdag = function(bn, data, strict = FALSE, debug = FALSE) {

  assign(".test.counter", 0, envir = .GlobalEnv)
  assign(".test.counter.permut", 0, envir = .GlobalEnv)

  # check bn's class.
  check.bn(bn)
  # check the data are there.
  check.data(data)
  # check the network against the data.
  check.bn.vs.data(bn, data)
  # check the logical flags (debug, strict).
  check.logical(debug)
  check.logical(strict)
  # check if the network is undirected.
  check.bn.undirected(bn)

  # recover some arc directions.
  res = second.principle(x = data, mb = bn$nodes,
        whitelist = bn$learning$whitelist,
        blacklist = bn$learning$blacklist, test = bn$learning$test,
        alpha = bn$learning$args$alpha, B = bn$learning$args$B,
        strict = strict, debug = debug)
  
  # restore the original learning parameters.
  res$learning$algo = bn$learning$algo
  res$learning$optimized = bn$learning$optimized
  
  # update counters.
  if (length(bn$learning$ntests) > 0)
    if (length(res$learning$ntests) > 0)
      res$learning$ntests = res$learning$ntests + bn$learning$ntests
    else
      res$learning$ntests = bn$learning$ntests
  if (length(bn$learning$nscores) > 0)
    if (length(res$learning$nscores) > 0)
      res$learning$nscores = res$learning$nscores + bn$learning$nscores
    else
      res$learning$ntests = bn$learning$nscores

  invisible(structure(res, class = "bn"))

}#SKELETON2PDAG

# test the equality of two network structures.
all.equal.bn = function(target, current, ...) {

  # check the class of target and current.
  check.bn(target)
  check.bn(current)
  # warn about unused arguments.
  check.unused.args(list(...), character(0))

  equal.backend(target, current)

}#ALL.EQUAL.BN

# compare two bayesian network structures.
compare = function(target, current, arcs = FALSE) {

  # check both objects' class.
  check.bn(target)
  check.bn(current)
  # the two networks must have the same node set.
  match.bn(target, current)
  # check debug.
  check.logical(arcs)

  # cache some useful quantities.
  nodes = names(target$nodes)
  nnodes = length(target$nodes)

  # separate directed and undirected arcs in the target network.
  which.dir = which.directed(target$arcs, nodes)
  target.dir = target$arcs[which.dir, , drop = FALSE]
  target.und = target$arcs[!which.dir, , drop = FALSE]
  # separate directed and undirected arcs in the current network.
  which.dir = which.directed(current$arcs, nodes)
  current.dir = current$arcs[which.dir, , drop = FALSE]
  current.und = current$arcs[!which.dir, , drop = FALSE]

  # treat directed and undirected arcs separately; directed arcs are
  # compared in both presence and direction.
  which.tp.dir = which.listed(target.dir, current.dir)
  which.tp.und = which.listed(target.und, current.und)
  which.fn.dir = !which.listed(target.dir, current.dir)
  which.fn.und = !which.listed(target.und, current.und)
  which.fp.dir = !which.listed(current.dir, target.dir)
  which.fp.und = !which.listed(current.und, target.und)

  if (arcs) {

    # return the arcs corresponding to each category.
    tp = arcs.rbind(target.dir[which.tp.dir, , drop = FALSE],
                    target.und[which.tp.und, , drop = FALSE])
    fn = arcs.rbind(target.dir[which.fn.dir, , drop = FALSE],
                    target.und[which.fn.und, , drop = FALSE])
    fp = arcs.rbind(current.dir[which.fp.dir, , drop = FALSE],
                    current.dir[which.fp.und, , drop = FALSE])

  }#THEN
  else {

    # return the counts for each category.
    tp = length(which(which.tp.dir)) + length(which(which.tp.und))/2
    fn = length(which(which.fn.dir)) + length(which(which.fn.und))/2
    fp = length(which(which.fp.dir)) + length(which(which.fp.und))/2

  }#ELSE

  return(list(tp = tp, fp = fp, fn = fn))

}#COMPARE

subgraph = function(x, nodes) {

  # check x's class.
  check.bn(x)
  # check the node ordering.
  check.nodes(nodes, graph = x, min.nodes = 3, max.nodes = length(x$nodes))

  subgraph.backend(x = x, nodes = nodes)

}#SUBGRAPH

