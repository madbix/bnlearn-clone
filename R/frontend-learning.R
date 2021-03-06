
# Grow-Shrink frontend.
gs = function(x, cluster = NULL, whitelist = NULL, blacklist = NULL,
    test = NULL, alpha = 0.05, B = NULL, debug = FALSE, optimized = TRUE,
    strict = FALSE, undirected = FALSE) {

  bnlearn(x = x, cluster = cluster, whitelist = whitelist,
    blacklist = blacklist, test = test, alpha = alpha, B = B, debug = debug,
    optimized = optimized, strict = strict, undirected = undirected)

}#GS

# Incremental Association frontend.
iamb = function(x, cluster = NULL, whitelist = NULL, blacklist = NULL,
    test = NULL, alpha = 0.05, B = NULL, debug = FALSE, optimized = TRUE,
    strict = FALSE, undirected = FALSE) {

  bnlearn(x = x, cluster = cluster, whitelist = whitelist,
    blacklist = blacklist, test = test, alpha = alpha, B = B, method = "iamb",
    debug = debug, optimized = optimized, strict = strict,
    undirected = undirected)

}#IAMB

# Fast-IAMB frontend.
fast.iamb = function(x, cluster = NULL, whitelist = NULL, blacklist = NULL,
    test = NULL, alpha = 0.05, B = NULL, debug = FALSE, optimized = TRUE,
    strict = FALSE, undirected = FALSE) {

  bnlearn(x = x, cluster = cluster, whitelist = whitelist,
    blacklist = blacklist, test = test, alpha = alpha, B = B,
    method = "fast.iamb", debug = debug, optimized = optimized,
    strict = strict, undirected = undirected)

}#FAST.IAMB

# Inter-IAMB frontend.
inter.iamb = function(x, cluster = NULL, whitelist = NULL, blacklist = NULL,
    test = NULL, alpha = 0.05, B = NULL, debug = FALSE, optimized = TRUE,
    strict = FALSE, undirected = FALSE) {

  bnlearn(x = x, cluster = cluster, whitelist = whitelist,
    blacklist = blacklist, test = test, alpha = alpha, B = B,
    method = "inter.iamb", debug = debug, optimized = optimized,
    strict = strict, undirected =  undirected)

}#INTER.IAMB

# MMPC frontend.
mmpc = function(x, cluster = NULL, whitelist = NULL, blacklist = NULL,
    test = NULL, alpha = 0.05, B = NULL, debug = FALSE, optimized = TRUE,
    strict = FALSE, undirected = FALSE) {

  bnlearn(x = x, cluster = cluster, whitelist = whitelist,
    blacklist = blacklist, test = test, alpha = alpha, B = B,
    method = "mmpc", debug = debug, optimized = optimized,
    strict = strict, undirected = undirected)

}#MMPC

# HPC frontend.
hpc = function(x, cluster = NULL, whitelist = NULL, blacklist = NULL,
               test = NULL, alpha = 0.05, B = NULL, debug = FALSE,
               optimized = TRUE, strict = FALSE, undirected = FALSE,
               nbr.join = "AND", nbr.method = "inter.iapc") {

  bnlearn(x = x, cluster = cluster, whitelist = whitelist,
          blacklist = blacklist, test = test, alpha = alpha, B = B,
          method = "hpc", debug = debug, optimized = optimized,
          strict = strict, undirected = undirected, nbr.join = nbr.join,
          nbr.method = nbr.method)

}#HPC

# HPC frontend (cached).
hpc.cached = function(x, whitelist = NULL, blacklist = NULL,
                      test = NULL, alpha = 0.05, B = NULL, debug = FALSE,
                      strict = FALSE, undirected = FALSE, nbr.method = "inter.iapc") {

  bnlearn(x = x, cluster = NULL, whitelist = whitelist,
          blacklist = blacklist, test = test, alpha = alpha, B = B,
          method = "hpc.cached", debug = debug, strict = strict,
          undirected = undirected, nbr.method = nbr.method)

}#HPC.CACHE

# ARACNE frontend.
aracne = function(x, whitelist = NULL, blacklist = NULL, mi = NULL,
    debug = FALSE) {

  mi.matrix(x = x, whitelist = whitelist, blacklist = blacklist,
    method = "aracne", mi = mi, debug = debug)

}#ARACNE

# Chow-Liu frontend.
chow.liu  = function(x, whitelist = NULL, blacklist = NULL, mi = NULL,
    debug = FALSE) {

  mi.matrix(x = x, whitelist = whitelist, blacklist = blacklist,
    method = "chow.liu", mi = mi, debug = debug)

}#CHOW.LIU

# Hill Climbing greedy search frontend.
hc = function(x, start = NULL, whitelist = NULL, blacklist = NULL,
    score = NULL, ..., debug = FALSE, restart = 0, perturb = 1,
    max.iter = Inf, optimized = TRUE) {

  greedy.search(x = x, start = start, whitelist = whitelist,
    blacklist = blacklist, score = score, heuristic = "hc",
    debug = debug, expand = c(list(...), restart = restart,
    perturb = perturb, max.iter = max.iter), optimized = optimized)

}#HC

# TABU list greedy search frontend.
tabu = function(x, start = NULL, whitelist = NULL, blacklist = NULL,
    score = NULL, ..., debug = FALSE, tabu = 10, max.tabu = tabu,
    max.iter = Inf, optimized = TRUE) {

  greedy.search(x = x, start = start, whitelist = whitelist,
    blacklist = blacklist, score = score, heuristic = "tabu",
    debug = debug, expand = c(list(...), max.iter = max.iter,
    tabu = tabu, max.tabu = max.tabu), optimized = optimized)

}#TABU

# Generic Restricted Maximization frontend.
rsmax2 = function(x, whitelist = NULL, blacklist = NULL, restrict = "gs",
    maximize = "hc", test = NULL, score = NULL, alpha = 0.05, B = NULL,
    ..., maximize.args = list(), optimized = TRUE, strict = FALSE,
    debug = FALSE) {

  restrict.args = list(test = test, alpha = alpha, B = B, strict = strict)
  maximize.args = list(...)

  hybrid.search(x, whitelist = whitelist, blacklist = blacklist,
    restrict = restrict, maximize = maximize, score = score,
    restrict.args = restrict.args, maximize.args = maximize.args,
    optimized = optimized, debug = debug)

}#RSHC

# MMHC frontend.
mmhc = function(x, whitelist = NULL, blacklist = NULL, test = NULL,
    score = NULL, alpha = 0.05, B = NULL, ..., restart = 0, perturb = 1,
    max.iter = Inf, optimized = TRUE, strict = FALSE, debug = FALSE) {

  restrict.args = list(test = test, alpha = alpha, B = B, strict = strict)
  maximize.args = c(list(...), restart = restart,
                   perturb = perturb, max.iter = max.iter)

  hybrid.search(x, whitelist = whitelist, blacklist = blacklist,
    restrict = "mmpc", maximize = "hc", restrict.args = restrict.args,
    maximize.args = maximize.args, score = score, optimized = optimized, debug = debug)

}#MMHC

# H2PC frontend.
h2pc = function(x, whitelist = NULL, blacklist = NULL, test = NULL,
    score = NULL, alpha = 0.05, B = NULL, ..., tabu = 100,
    max.tabu = 15, optimized = TRUE, strict = FALSE, debug = FALSE,
    nbr.join = "AND", nbr.method = "inter.iapc") {

  restrict.args = list(test = test, alpha = alpha, B = B, strict = strict,
        nbr.join = nbr.join, nbr.method = nbr.method)
  maximize.args = c(list(...), tabu = tabu, max.tabu = max.tabu)

  hybrid.search(x, whitelist = whitelist, blacklist = blacklist,
    restrict = "hpc", maximize = "tabu", restrict.args = restrict.args,
    maximize.args = maximize.args, score = score, optimized = optimized,
    debug = debug)

}#H2PC

# Frontend for the Markov blanket learning algorithms.
learn.mb = function(x, node, method, whitelist = NULL, blacklist = NULL,
                    test = NULL, alpha = 0.05, B = NULL, debug = FALSE,
                    optimized = TRUE, method.args = NULL) {

  mb.backend(x, node = node, method = method, method.args = method.args,
             whitelist = whitelist, blacklist = blacklist, test = test,
             alpha = alpha, B = B, debug = debug, optimized = optimized)

}#LEARN.MB

# Frontend for the parents and children learning algorithms.
learn.pc = function(x, node, method, whitelist = NULL, blacklist = NULL,
                    test = NULL, alpha = 0.05, B = NULL, debug = FALSE,
                    optimized = TRUE, method.args = NULL) {

  pc.backend(x, node = node, method = method, method.args = method.args,
             whitelist = whitelist, blacklist = blacklist, test = test,
             alpha = alpha, B = B, debug = debug, optimized = optimized)

}#LEARN.PC

# naive Bayes frontend.
naive.bayes = function(training, explanatory, data) {

  bayesian.classifier(data, training = training, explanatory = explanatory,
    method = "naive", whitelist = NULL, blacklist = NULL, expand = list())

}#NAIVE.BAYES

# tree-augmented naive Bayes frontend.
tree.bayes = function(x, training, explanatory, whitelist = NULL, blacklist = NULL,
    mi = NULL, root = NULL) {

  bayesian.classifier(x, training = training, explanatory = explanatory,
    method = "tan", whitelist = whitelist, blacklist = blacklist,
    expand = list(estimator = mi, root = root))

}#TAN
