#!/usr/bin/env Rscript

library(ggplot2)
library(dplyr)
library(tidyr)

#library(showtext)
#font_add_google("Lato")
#showtext_auto()

df <- read.csv("big_exp_41/tputs.mm", sep=" ")
df <- df %>% gather("measurement", "value", delay, bundle, cross)
df_switch <- read.csv("big_exp_41/bundler.switch", sep=",")

plt <- ggplot(df, aes(x=t, y=value, color=measurement)) + 
    geom_line(size=0.5) +
    geom_rect(data=df_switch, inherit.aes=FALSE, show.legend=FALSE, aes(xmin=xmin,xmax=xmax,ymin=0,ymax=max(df$value),fill="xtcp"), alpha=0.2) +
    geom_vline(xintercept=60) + geom_vline(xintercept=120) +
    facet_wrap(~Traffic, ncol=1, strip.position="right") + 
    xlab("Time (seconds)") + 
    scale_x_continuous(expand = c(0, 0), limits=c(0,180), breaks=c(0,20,40,60,80,100,120,140,160,180)) +
    scale_y_continuous("Throughput (Mbps)", sec.axis = dup_axis(name="Delay (ms)")) +
    scale_fill_manual('Mode', values="black", labels=c("xtcp")) +
    scale_colour_brewer(type="qual", palette=2, limits=c("bundle", "cross", "delay"), labels=c("bundle"="Bundler Throughput", "cross"="Cross-Traffic Throughput", "delay"="In-Network Queueing Delay")) +
    theme_bw() +
    theme(
        text = element_text(angle=0,size=14, face="bold"),
        legend.position = "top",
        legend.title=element_blank(),
        legend.key.width = unit(0.75,"cm"),
        legend.key.size = unit(0.5, 'lines'),
        legend.spacing.x = unit(0.2, 'cm')
     ) +
    guides(color = guide_legend(override.aes = list(size = 2)))

ggsave("mm.pdf", plt, width=15, height=3)
warnings()
