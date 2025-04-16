return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.11.2",
  class = "",
  orientation = "isometric",
  renderorder = "right-down",
  width = 16,
  height = 16,
  tilewidth = 64,
  tileheight = 32,
  nextlayerid = 6,
  nextobjectid = 17,
  properties = {},
  tilesets = {
    {
      name = "tileset_desert",
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
      width = 16,
      height = 16,
      id = 1,
      name = "floor",
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
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
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
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 224,
          y = 96,
          width = 64,
          height = 32,
          rotation = 0,
          gid = 239,
          visible = true,
          properties = {
            ["footprint"] = "cross1"
          }
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 64,
          width = 64,
          height = 32,
          rotation = 0,
          gid = 223,
          visible = true,
          properties = {
            ["footprint"] = "cross1"
          }
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 288,
          y = 96,
          width = 64,
          height = 32,
          rotation = 0,
          gid = 237,
          visible = true,
          properties = {
            ["footprint"] = "cross2"
          }
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 64,
          width = 64,
          height = 32,
          rotation = 0,
          gid = 221,
          visible = true,
          properties = {
            ["footprint"] = "cross2"
          }
        },
        {
          id = 9,
          name = "npc",
          type = "",
          shape = "point",
          x = 236.71,
          y = 77.1182,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["npc"] = "trader"
          }
        }
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
      properties = {},
      objects = {
        {
          id = 6,
          name = "cross1",
          type = "",
          shape = "polygon",
          x = 194.011,
          y = 66.5817,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 18.8068, y = 1.55857 },
            { x = 20.5731, y = 20.5731 },
            { x = 5.19524, y = 20.5731 }
          },
          properties = {}
        },
        {
          id = 7,
          name = "cross2",
          type = "",
          shape = "polygon",
          x = 262.9,
          y = 83.3103,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 19.7419, y = -0.207809 },
            { x = 18.1833, y = -7.37724 },
            { x = -1.76638, y = -7.79286 }
          },
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "polygon",
          x = 512,
          y = 224,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = 32 },
            { x = 32, y = 32 },
            { x = 32, y = 0 }
          },
          properties = {
            ["exit"] = "desert"
          }
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "polygon",
          x = 213.989,
          y = 92.0828,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 13.1625, y = 22.6395 },
            { x = 49.6665, y = 38.0835 },
            { x = 57.5641, y = 11.934 },
            { x = 51.9481, y = -3.51 },
            { x = 35.802, y = -36.504 },
            { x = 21.2355, y = -41.5935 },
            { x = 0, y = -49.842 },
            { x = -8.77501, y = -28.431 }
          },
          properties = {
            ["dialog"] = "trader"
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
          id = 1,
          name = "playerSpawn",
          type = "",
          shape = "point",
          x = 491.5,
          y = 238.5,
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
