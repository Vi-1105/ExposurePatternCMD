##1.XGBoost####
model_xgb <- xgb.train(params = param, 
                        data = trainMat,
                        nrounds = m_nround, 
                        watchlist = list(val2 = trainMat),
                        early_stopping_rounds = st_nround)
##2.K-Prototypes clustering####
KP_result <- kproto(cluster_data[, exposure_vars], k = 5)

##3.LASSO regression#####
best_model <- glmnet(X, cluster, intercept = FALSE,
                      family = "multinomial", alpha = 1, lambda = best_lambda)
##4.Enrichment####
ego <- clusterProfiler::enrichGO(gene  =  genes,
                                 OrgDb  =  "org.Hs.eg.db",
                                 keyType = "SYMBOL",
                                 ont ="all", 
                                 pAdjustMethod = "bonferroni",
                                 qvalueCutoff = 0.05)
ekegg <-clusterProfiler::enrichKEGG(gene = trans$ENTREZID ,
                                    organism = "hsa",
                                    keyType = "kegg",
                                    pvalueCutoff = 0.05,
                                    pAdjustMethod = "BH",
                                    qvalueCutoff = 0.05)
##5.Mediation####
est <- cmest(data = data_mediation, model = "rb", 
             outcome = time_need,
             event = outcome_need, exposure = exposure_need,
             mediator = mediator_need, basec =covariates1, 
             mreg = list("linear"), yreg = 'coxph', 
             astar = 0, a = 1, mval = list(0),
             estimation = "paramfunc", 
             inference = "delta")