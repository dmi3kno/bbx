library(magick)
library(bunny)
p2_clouds <- image_read("data-raw/fantasy-4065903_1920.jpg") %>%
  image_convert("png")
p2_clouds

up_hand <- p2_clouds %>% image_crop("1200x900+0+0") %>%
  image_convert(colorspace = "Gray") %>%
  image_threshold("white", "40%") %>%
  image_threshold("black", "30%")

down_hand <- p2_clouds %>% image_crop("1200x1200+750+870") %>%
  image_convert(colorspace = "Gray") %>%
  image_threshold("white", "40%") %>%
  image_threshold("black", "30%")

up_hand <- up_hand %>%
  image_negate() %>%
  image_morphology("Erode", "Diamond") %>%
  image_morphology("Smooth", "Disk:1.2") %>%
  image_negate() %>%
  image_transparent("white", 10) %>%
  image_resize(geometry_size_pixels(700), "Lanczos2")

down_hand <- down_hand %>%
  image_negate() %>%
  image_morphology("Erode", "Diamond") %>%
  image_morphology("Smooth", "Disk:1.2") %>%
  image_negate() %>%
  image_transparent("white", 10) %>%
  image_resize(geometry_size_pixels(700), "Lanczos2")

down_hand

up_hand_shadow <- up_hand %>%
  image_colorize(50, "grey") %>%
  image_blur(20,10)

down_hand_shadow <- down_hand %>%
  image_colorize(50, "grey") %>%
  image_blur(20,10)

up_hand_shadow

# https://coolors.co/000000-ede6f2-0d4448-c8c8c8-b3b3b3
hex_canvas <- image_canvas_hex(border_color="#0d4448", border_size = 2, fill_color = "#ede6f2")
hex_border <- image_canvas_hexborder(border_color="#0d4448", border_size = 4)
hex_canvas

img_hex <- hex_canvas %>%
  bunny::image_compose(up_hand_shadow, offset="+40+460", gravity = "northwest")%>%
  bunny::image_compose(down_hand_shadow, offset="+30+390", gravity = "southeast")%>%
  bunny::image_compose(up_hand, offset="+20+440", gravity = "northwest")%>%
  bunny::image_compose(down_hand, offset="+20+380", gravity = "southeast")%>%
  image_annotate("bbx", size=450, gravity = "center", font = "Aller", color = "#0d4448") %>%
  bunny::image_compose(hex_border, gravity = "center", operator = "Over")
img_hex

img_hex %>%
  image_scale("1200x1200") %>%
  image_write(here::here("data-raw", "bbx_hex.png"), density = 600)

if(!dir.exists("man/figures"))
  dir.create("man/figures")

img_hex %>%
  image_scale("200x200") %>%
  image_write(here::here("man","figures","logo.png"), density = 600)

img_hex_gh <- img_hex %>%
  image_scale("400x400")

gh_logo <- bunny::github %>%
  image_scale("50x50")

gh <- image_canvas_ghcard("#ede6f2") %>%
  image_compose(img_hex_gh, gravity = "East", offset = "+100+0") %>%
  image_annotate("Frame your world", gravity = "West", location = "+100-30",
                 color="#0d4448", size=60, font="Aller", weight = 700) %>%
  image_compose(gh_logo, gravity="West", offset = "+100+40") %>%
  image_annotate("dmi3kno/bbx", gravity="West", location="+160+45",
                 size=50, font="Ubuntu Mono") %>%
  image_border_ghcard("#ede6f2")

gh

gh %>%
  image_write(here::here("data-raw", "bbx_ghcard.png"))
