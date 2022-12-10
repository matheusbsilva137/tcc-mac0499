library("ggplot2")
install.packages("dplyr")
library("dplyr")

# Bloom filter

df <- read.csv("bloom-filter.csv")
test_times <- df[, -1]
x <- 1:20
y <- rowMeans(test_times)
s <- apply(test_times, 1, FUN = sd)
data_bloom <- data.frame(x, y)
n <- 30

margin <- qt(0.975, df = n - 1) * s / sqrt(n)
ymin <- y - margin
ymax <- y + margin

ggplot(data_bloom, aes(x, y)) +
  geom_point() +
  geom_errorbar(aes(ymin = ymin, ymax = ymax)) +
  stat_smooth(method = lm) +
  xlab(expression(epsilon * " (%)")) +
  ylab("Tempo de execução (ms)") +
  ggtitle("Algoritmo de hifenização com Bloom filter: tempo médio de execução para todas as palavras do dicionário")

ggsave("bloom-filter.png")

# Build Bloom filter

df <- read.csv("build-bloom-filter.csv")
test_times <- df[, -1]
x <- 1:20
y <- rowMeans(test_times)
s <- apply(test_times, 1, FUN = sd)
data_build_bloom <- data.frame(x, y)
n <- 30

margin <- qt(0.975, df = n - 1) * s / sqrt(n)
ymin <- y - margin
ymax <- y + margin

ggplot(data_build_bloom, aes(x, y)) +
  geom_point() +
  geom_errorbar(aes(ymin = ymin, ymax = ymax)) +
  stat_smooth(method = lm) +
  xlab(expression(epsilon * " (%)")) +
  ylab("Tempo de execução (ms)") +
  ggtitle("Algoritmo de hifenização com Bloom filter: tempo médio de construção do filtro")

ggsave("build-bloom-filter.png")

# Cuckoo filter

df <- read.csv("cuckoo-filter.csv")
test_times <- df[, -1]
x <- 1:20
y <- rowMeans(test_times)
s <- apply(test_times, 1, FUN = sd)
data_cuckoo <- data.frame(x, y)
n <- 30

margin <- qt(0.975, df = n - 1) * s / sqrt(n)
ymin <- y - margin
ymax <- y + margin

ggplot(data_cuckoo, aes(x, y)) +
  geom_point() +
  geom_errorbar(aes(ymin = ymin, ymax = ymax)) +
  stat_smooth(method = lm) +
  xlab(expression(epsilon * " (%)")) +
  ylab("Tempo de execução (ms)") +
  ggtitle("Algoritmo de hifenização com Cuckoo filter: tempo médio de execução para todas as palavras do dicionário")

ggsave("cuckoo-filter.png")

# Build Cuckoo filter

df <- read.csv("build-cuckoo-filter.csv")
test_times <- df[, -1]
x <- 1:20
y <- rowMeans(test_times)
s <- apply(test_times, 1, FUN = sd)
data_build_cuckoo <- data.frame(x, y)
n <- 30

margin <- qt(0.975, df = n - 1) * s / sqrt(n)
ymin <- y - margin
ymax <- y + margin

ggplot(data_build_cuckoo, aes(x, y)) +
  geom_point() +
  geom_errorbar(aes(ymin = ymin, ymax = ymax)) +
  stat_smooth(method = lm) +
  xlab(expression(epsilon * " (%)")) +
  ylab("Tempo de execução (ms)") +
  ggtitle("Algoritmo de hifenização com Cuckoo filter: tempo médio de construção do filtro")

ggsave("build-cuckoo-filter.png")

# Comparação

df2 <- bind_rows(data_bloom, data_cuckoo, .id = "Filtro")
df2$Filtro[df2$Filtro == 1] <- "Bloom filter"
df2$Filtro[df2$Filtro == 2] <- "Cuckoo filter"

ggplot(data = df2, aes(x = x, y = y, fill = Filtro, width = .5)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  xlab(expression(epsilon * " (%)")) +
  ylab("Tempo de execução (ms)") +
  ggtitle("Algoritmo de hifenização: comparação entre os tempos médios de execução com Bloom filter e Cuckoo filter")

ggsave("cuckoo-bloom-comparison.png", width = 10, height = 5)

# Comparação - Build

df2 <- bind_rows(data_build_bloom, data_build_cuckoo, .id = "Filtro")
df2$Filtro[df2$Filtro == 1] <- "Bloom filter"
df2$Filtro[df2$Filtro == 2] <- "Cuckoo filter"

ggplot(data = df2, aes(x = x, y = y, fill = Filtro, width = .5)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  xlab(expression(epsilon * " (%)")) +
  ylab("Tempo de execução (ms)") +
  ggtitle("Algoritmo de hifenização: comparação entre os tempos médios de construção do filtro")

ggsave("build-cuckoo-bloom-comparison.png", width = 10, height = 5)