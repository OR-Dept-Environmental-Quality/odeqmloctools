library(readxl)
library(odeqmloctools)

mloc_example <- read_excel("test/mloc_example.xlsx",
                           col_types = c("text", "text", "text", "numeric", "numeric",
                                         "text", "text", "numeric", "text", "text", "text",
                                         "text", "text", "text", "text", "text",
                                         "text", "text", "text", "text", "text",
                                         "text", "text", "numeric", "text",
                                         "numeric", "text", "text", "text",
                                         "text", "text", "text", "text", "text",
                                         "text", "text", "text", "text", "text"))

names(mloc_example) <- make.names(names(mloc_example))

mloc_example <- as.data.frame(mloc_example)

save(mloc_example, file="test/mloc_example.RData")
