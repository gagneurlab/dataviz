## prepare dataset for case study
library(genomeIntervals)
library(genefilter)

growth = read.delim("/localdata/genenv/growth_rate.txt", comment.char = "#")

load("/localdata/genenv/geno_mrk.rda")

strain = intersect(levels(growth$strain), rownames(geno))

## growth
growth <- growth [match(strain, growth$strain), c("YPD", "YPD_BPS", "YPD_Rapa", "YPE", "YPMalt")]

growth$strain = strain
growth = growth[,c(6,1:5)]

## markers
mrki = seq(1, ncol(geno), length.out=1e3)
marker <- data.frame(
  chrom = seq_name(mrk),
  start = mrk[,1],
  end = mrk[,2]
)[mrki,]

## genotype at markers and strains
G = geno[strain,mrki]
genotype <- data.frame(
  matrix(ifelse(as.vector(G)==0, "Lab strain", "Wild isolate"), ncol=ncol(G))
)
rownames(genotype) <- strain
colnames(genotype) <- rownames(marker)

genotype$strain = strain
genotype = genotype[,c(ncol(genotype),1:(ncol(genotype)-1))]

write.table(genotype, "~/project/dataviz/lectures/extdata/eqtl/genotype.txt", sep="\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

write.table(growth, "~/project/dataviz/lectures/extdata/eqtl/growth.txt", sep="\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

marker$id = rownames(marker)
marker = marker[,c(ncol(marker),1:(ncol(marker)-1))] 

write.table(marker, "~/project/dataviz/lectures/extdata/eqtl/marker.txt", sep="\t", col.names = TRUE, row.names = FALSE, quote = FALSE)
