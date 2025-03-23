return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.11.2",
  class = "",
  orientation = "isometric",
  renderorder = "right-down",
  width = 8,
  height = 8,
  tilewidth = 64,
  tileheight = 32,
  nextlayerid = 7,
  nextobjectid = 16,
  properties = {},
  tilesets = {
    {
      name = "desert_tileset",
      firstgid = 1,
      class = "",
      tilewidth = 64,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "../../assets/maps/tileset_desert.png",
      imagewidth = 1024,
      imageheight = 1129,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 64,
        height = 32
      },
      properties = {},
      wangsets = {},
      tilecount = 560,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      id = 1,
      name = "ground",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        1, 24, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1,
        1, 24, 1, 1, 1, 1, 1, 1,
        1, 1, 24, 24, 24, 1, 1, 1,
        1, 24, 24, 1, 24, 1, 1, 1,
        1, 1, 24, 24, 24, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      id = 3,
      name = "decorative",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 534, 0, 0,
        0, 0, 0, 0, 533, 0, 550, 0,
        0, 0, 0, 0, 0, 549, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "sprites",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 160,
          width = 64,
          height = 32,
          rotation = 0,
          gid = 505,
          visible = true,
          properties = {
            ["collidable"] = false,
            ["sortPos"] = "3,4"
          }
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 96,
          y = 128,
          width = 64,
          height = 32,
          rotation = 0,
          gid = 489,
          visible = true,
          properties = {
            ["sortPos"] = "3,4"
          }
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 64,
          y = 96,
          width = 64,
          height = 32,
          rotation = 0,
          gid = 473,
          visible = true,
          properties = {
            ["sortPos"] = "3,4"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
      name = "collisions",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 94.8873,
          y = 126.239,
          width = 36.6197,
          height = 36.6197,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "player",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 4,
          name = "playerSpawn",
          type = "",
          shape = "point",
          x = 143.479,
          y = 110.042,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
