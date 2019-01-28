#!/usr/bin/Rscript

library(ggplot2)
library(showtext)
font_add_google("Lato")
showtext_auto()

args <- commandArgs(trailingOnly=TRUE)
df <- read.csv(args[1], sep=" ")
df$Time <- df$Time - min(df$Time)

ggplot(df, aes(x=Time, y=Delay)) + geom_line(size=2) + coord_cartesian(xlim=c(0,30), ylim=c(0,150)) + theme_minimal() +
    ylab("Queue (pkts)") +
    theme(
        text = element_text(size=18, family="Lato", face="bold")
    )

ggsave(args[2], width=6, height=2)
