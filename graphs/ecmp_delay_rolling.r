# NOTE: paths are relative to the root of the repo
library(ggplot2)
library(dplyr)
library(tidyr)
library(patchwork)
library(zoo)

# args = commandArgs(trailingOnly=TRUE)
# inbox_name <- args[1]
# mm_name <- args[2]
# inbox <- read.csv(inbox_name, sep=" ")
# mm <- read.csv(mm_name, sep=" ")
inbox <- read.csv("graphs/data/test-fork-4-4q.inbox", sep=" ")
mm <- read.csv("graphs/data/test-fork-4-4q.mm", sep=" ")

# compute rolling mean to smooth out the graph and make trends clearer
norm <- inbox %>% filter(order == "normal")
norm$rolling <- rollmean(norm$rtt/1000, 2, na.pad=TRUE)
ooo <- inbox %>% filter(order == "ooo")
ooo$rolling <- rollmean(ooo$rtt/1000, 25, na.pad=TRUE)
inbox <- rbind(norm, ooo)

# compute rolling mean to smooth out the graph and make trends clearer
mm1 <- mm %>% filter(queue == "0")
mm1$rolling <- rollmean(mm1$delay, 1000, na.pad=TRUE)
mm2 <- mm %>% filter(queue == "1")
mm2$rolling <- rollmean(mm2$delay, 1000, na.pad=TRUE)
mm3 <- mm %>% filter(queue == "2")
mm3$rolling <- rollmean(mm3$delay, 1000, na.pad=TRUE)
mm4 <- mm %>% filter(queue == "3")
mm4$rolling <- rollmean(mm4$delay, 1000, na.pad=TRUE)
mm <- rbind(mm1,mm2,mm3,mm4)

# NOTE: we clip to 60s to 120s for eurosys to make it fit better

# bottom plot, in-order vs. out-of-order *RTT* measurement (hence min of 50ms)
p1 <- ggplot(inbox, aes(x=(t/1000)-60, y=rolling, color=order)) + geom_line(size=1.03) +
    xlab("Time (seconds)") + ylab(expression(atop("Observed RTT", "at bundler (ms)"))) +
    scale_x_continuous(expand=c(0,0), limits=c(0,60), breaks=seq(0,60,10)) + 
    scale_y_continuous(expand=c(0.01,0), limits=c(0,650), breaks=seq(0,600,200)) +
    scale_colour_grey(labels=c("ooo"="Out-Of-Order","normal"="In-Order")) +
    theme_bw() + theme(
        text = element_text(angle=0, size=26),
        axis.text.x = element_text(angle=0, size=26),
        axis.text.y = element_text(angle=0, size=26),
        axis.ticks = element_line(colour = "black", size = 1.25),
        axis.ticks.length=unit(.2, "cm"),
        legend.position = "bottom",
        legend.title=element_blank(),
        legend.text=element_text(size=26),
        legend.key.width = unit(2,"cm"),
        legend.key.size = unit(2, "lines"),
        legend.spacing.x = unit(0.25, "cm"),
        panel.border = element_rect(colour = "black", fill=NA, size=1)
    ) + guides(color = guide_legend(override.aes = list(size = 2.5)))

# top plot, queueing delay per-path
p2 <- ggplot(mm, aes(x=(t/1000)-60, y=rolling, color=factor(queue))) + geom_line(size=1.03) +
    xlab("Time (seconds)") + ylab(expression(atop("Per-Queue Delay","at bottleneck (ms)"))) +
    scale_x_continuous(expand=c(0,0), limits=c(0,60)) + 
    scale_y_continuous(expand=c(0.01,0), limits=c(0,650), breaks=seq(0,600,200)) +
    scale_colour_brewer(name="Path", type="qual", palette = "Set1", labels=c("0"="1", "1"="2", "2"="3", "3"="4")) +
    theme_bw() + theme(
        text = element_text(angle=0, size=26),
        legend.position = "top",
        legend.title=element_text(size=26),
        axis.ticks = element_line(colour = "black", size = 1.25),
        axis.ticks.length=unit(0.2, "cm"),
        axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y = element_text(angle=0, size=26),
        legend.text=element_text(size=26),
        legend.key.width = unit(1.5,"cm"),
        legend.key.size = unit(2, "lines"),
        legend.spacing.x = unit(0.25, "cm"),
        panel.border = element_rect(colour = "black", fill=NA, size=1)
    ) + 
    guides(color = guide_legend(override.aes = list(size = 2.5)))

# needed a bit of margin on the right 
(p2 / p1) + plot_annotation(theme = theme(plot.margin = margin(0,1,0,0,"cm")))

ggsave("./figure/ecmp_delay.pdf", height=8, width=11)
