#!/usr/bin/Rscript

library(ggplot2)
library(showtext)
font_add_google("Lato")
showtext_auto()

args <- commandArgs(trailingOnly=TRUE)
df <- read.csv(args[1], sep=" ")
df$Time <- df$Time - min(df$Time)
df$Qlen <- df$Qlen / 2
#
ggplot(df[sample(nrow(df), 1000), ], aes(x=Time, y=Qlen)) + geom_line(size=2) + coord_cartesian(xlim=c(25,55), ylim=c(0,150)) + theme_minimal() +
    ylab("Queue (pkts)") +
    theme(
        text = element_text(size=18, family="Lato", face="bold")
    )

ggsave(args[2], width=6, height=2)
