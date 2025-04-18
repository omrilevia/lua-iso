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
  nextlayerid = 9,
  nextobjectid = 44,
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
        0, 0, 0, 0, 0, 532, 0, 0,
        0, 0, 0, 0, 531, 0, 548, 0,
        0, 0, 0, 0, 0, 547, 0, 0
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
            ["footprint"] = "cactus"
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
            ["footprint"] = "cactus"
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
            ["footprint"] = "cactus"
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
          id = 36,
          name = "cactus",
          type = "",
          shape = "polygon",
          x = 125.596,
          y = 159.102,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -5.28151, y = 1.92817 },
            { x = -6.95818, y = -0.0838335 },
            { x = -7.62885, y = -4.44318 },
            { x = -4.69468, y = -6.70668 },
            { x = -1.84434, y = -9.55702 },
            { x = 0.922169, y = -6.62285 }
          },
          properties = {
            ["footprint"] = "cactus"
          }
        },
        {
          id = 40,
          name = "",
          type = "",
          shape = "polygon",
          x = 0,
          y = 128,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = -32 },
            { x = -32, y = -64 },
            { x = -32, y = -32 }
          },
          properties = {
            ["exit"] = "cemetary"
          }
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
          x = 17.2467,
          y = 116.292,
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
