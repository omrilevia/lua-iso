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
  nextobjectid = 26,
  properties = {},
  tilesets = {
    {
      name = "snow sheet",
      firstgid = 1,
      class = "",
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "../../assets/maps/snowplains_tileset.png",
      imagewidth = 1024,
      imageheight = 1024,
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
        height = 64
      },
      properties = {},
      wangsets = {},
      tilecount = 256,
      tiles = {
        {
          id = 200,
          properties = {
            ["solid"] = false
          }
        }
      }
    },
    {
      name = "snowplains_tileset",
      firstgid = 257,
      class = "",
      tilewidth = 64,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "../../assets/maps/snowplains_tileset.png",
      imagewidth = 1024,
      imageheight = 1024,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "isometric",
        width = 64,
        height = 32
      },
      properties = {},
      wangsets = {},
      tilecount = 512,
      tiles = {
        {
          id = 468,
          properties = {
            ["solid"] = false
          }
        }
      }
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
      properties = {
        ["collidable"] = false
      },
      encoding = "lua",
      data = {
        18, 18, 18, 18, 18, 18, 18, 18,
        18, 18, 18, 18, 18, 18, 18, 18,
        18, 17, 17, 17, 17, 17, 18, 18,
        18, 18, 18, 18, 18, 18, 18, 18,
        18, 18, 18, 18, 18, 18, 18, 18,
        18, 18, 18, 18, 18, 18, 18, 18,
        18, 18, 18, 18, 18, 18, 18, 18,
        18, 18, 18, 18, 18, 18, 18, 18
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      id = 2,
      name = "grass",
      class = "",
      visible = true,
      opacity = 0.83,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {
        ["collidable"] = false
      },
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 211, 211, 211, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      id = 3,
      name = "box thing",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {
        ["collidable"] = true
      },
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 627, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 184, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "collisions",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {
        ["collidable"] = false
      },
      objects = {
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 20,
          y = 120,
          width = 52.5,
          height = 43.5,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 191.5,
          y = 24.5,
          width = 34.5,
          height = 41.5,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 95.5,
          y = -11.5,
          width = 0,
          height = 0,
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
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 224,
          y = 128,
          width = 64,
          height = 32,
          rotation = 0,
          gid = 758,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["pos"] = "6,3",
            ["sortPos"] = "6,3"
          }
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 96,
          width = 64,
          height = 32,
          rotation = 0,
          gid = 742,
          visible = true,
          properties = {
            ["collidable"] = false,
            ["pos"] = "5,2",
            ["sortPos"] = "6,3"
          }
        },
        {
          id = 15,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 64,
          width = 64,
          height = 32,
          rotation = 0,
          gid = 726,
          visible = true,
          properties = {
            ["collidable"] = false,
            ["pos"] = "4,1",
            ["sortPos"] = "6,3"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
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
          id = 16,
          name = "",
          type = "",
          shape = "point",
          x = 15.4783,
          y = 15.5776,
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
