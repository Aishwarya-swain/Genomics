library(dplyr)
library(tidyr)
library(networkD3)
library(openxlsx)
library(RColorBrewer)
library(htmlwidgets)
library(webshot2) 

# Install packages if needed
# install.packages(c("dplyr","tidyr","networkD3"))
##here we have virulence andgenes and respective strains, the virulence file was retrived from thE VFDb and compiled for all the strains.


# Read your CSV file (change path to your file)
df <- read.xlsx("virulence.xlsx", check.names = FALSE)

df_long <- df %>%
  pivot_longer(
    cols = -`Related.genes`, 
    names_to = "Strain", 
    values_to = "Gene_ID"
  ) %>%
  filter(Gene_ID != "-") %>%   # remove "-"
  group_by(`Related.genes`, Strain) %>%
  summarise(value = n(), .groups = "drop")

# Create nodes for Sankey plot (unique genes and strains)
nodes <- data.frame(
  name = unique(c(df_long$`Related.genes`, df_long$Strain)),
  stringsAsFactors = FALSE
)

#Create links (with group = gene name for coloring)
links <- df_long %>%
  mutate(
    source = match(`Related.genes`, nodes$name) - 1,
    target = match(Strain, nodes$name) - 1,
    group  = `Related.genes`   # group by gene
  ) %>%
  select(source, target, value, group)

# Assign distinct colors per gene
gene_names <- unique(df_long$`Related.genes`)
color_palette <- colorRampPalette(brewer.pal(8, "Set2"))(length(gene_names))
names(color_palette) <- gene_names

# Map group (gene) to color
links$color <- color_palette[links$group]

# Build Sankey with link colors
sankey <- sankeyNetwork(
  Links = links,
  Nodes = nodes,
  Source = "source",
  Target = "target",
  Value = "value",
  NodeID = "name",
  LinkGroup = "group",   # color links by gene
  fontSize = 12,
  nodeWidth = 30
)

sankey

# install with remotes::install_github("rstudio/webshot2")

# Save interactive HTML (local use only)
saveWidget(sankey, "sankey.html", selfcontained = TRUE)

# Save as PNG (safe to email)
Requires installation of webshot2 package and installation of PhantomJS or Chrome
webshot("sankey.html", file = "sankey.png", vwidth = 1200, vheight = 2400)

