#!/usr/bin/env Rscript

library(ggplot2)
library(dplyr)
library(tidyr)

library(showtext)
showtext_auto()

df <- read.csv("big_exp_41/tputs.mm", sep=" ")
df <- df %>% gather("measurement", "value", delay, bundle, cross)
df_switch <- read.csv("big_exp_41/bundler.switch", sep=",")

plt <- ggplot(df, aes(x=t, y=value, color=measurement)) + 
    geom_line() +
    geom_rect(data=df_switch, inherit.aes=FALSE, aes(xmin=xmin,xmax=xmax,ymin=0,ymax=max(df$value),fill="xtcp"), alpha=0.2) +
    geom_vline(xintercept=60) + geom_vline(xintercept=120) +
    facet_wrap(~Traffic, ncol=1, strip.position="right") + 
    xlab("Time (seconds)") + 
    ylab(expression(atop("Throughput(Mbps)","Delay(ms)"))) +
    scale_x_continuous(expand = c(0, 0), limits=c(0,180), breaks=c(0,60,120,180)) +
    scale_fill_manual('Mode', values="black", labels=c("xtcp")) +
    theme_bw() + 
    theme(
        text = element_text(angle=0,size=14, family="Lato", face="bold"),
        legend.position = "none",
        legend.title=element_blank()
     )

ggsave("mm.pdf", plt, width=15, height=2.5)
