bv <- spocc::occ('Bradypus variegatus', 'gbif', limit=300, has_coords=TRUE)
occs <- as.data.frame(bv$gbif$data$Bradypus_variegatus[,2:3])
occs <- occs[!duplicated(occs),]
envs <- raster::stack(list.files(path=paste(system.file(package='dismo'), '/ex', sep=''), pattern='grd', full.names=TRUE))
envs <- raster::mask(envs, envs$biome)
which(rowSums(is.na(raster::extract(envs, occs))) > 0)
bg <- dismo::randomPoints(envs[[1]], 10000)
mod.args <- list(fc = "LQ", rm = 1)
p.block <- ENMeval::get.block(occs, bg)
envs.xy <- raster::rasterToPoints(envs[[1]], spatial = TRUE)
p.block$envs.grp <- ENMeval::get.block(occs, envs.xy@coords)$bg.grp
p.rand <- ENMeval::get.randomkfold(occs, bg, 3)
x1 <- nullENMs(occs, envs, bg, p.rand$occ.grp, p.rand$bg.grp, mod.name = "maxnet",
               mod.args = mod.args, no.iter = 5, eval.type = "kfold", categoricals = "biome")
# x2 <- nullENMs(occs, envs, bg, p.block$occ.grp, p.block$bg.grp, envs.grp = p.block$envs.grp, "maxnet", mod.args, 5, "kspatial", "biome")
# x3 <- nullENMs(occs[1:200,], envs, bg, occs.indTest = occs[201:nrow(occs),], mod.name = "maxnet", mod.args = mod.args, no.iter = 5, eval.type = "split", categoricals = "biome")
