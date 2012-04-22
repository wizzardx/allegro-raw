{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE EmptyDataDecls #-}
module Graphics.UI.Allegro.Raw.Bitmap where

import C2HS
import Internal
{#import Graphics.UI.Allegro.Raw.Color #}

#include "allegro-raw.h"
{#context prefix = "ALLEGRO_" #}

data Bitmap'
{#pointer *BITMAP as Bitmap -> Bitmap' #}

{#enum PIXEL_FORMAT as PixelFormat {underscoreToCase} deriving (Show, Eq, Ord, Read) #}

data BitmapFlags
    = MemoryBitmap
    | KeepBitmapFormat
    | ForceLocking
    | NoPreserveTexture
    | AlphaTest
    | UnderscoreInternalOpenGL
    | MinLinear
    | MagLinear
    | Mipmap
    | NoPremultipliedAlpha
    | VideoBitmap
      deriving (Show, Eq, Ord, Read)

instance Bounded BitmapFlags where
    minBound = MemoryBitmap
    maxBound = VideoBitmap

instance Enum BitmapFlags where
    toEnum 1     = MemoryBitmap
    toEnum 2     = KeepBitmapFormat
    toEnum 4     = ForceLocking
    toEnum 8     = NoPreserveTexture
    toEnum 0x10  = AlphaTest
    toEnum 0x20  = UnderscoreInternalOpenGL
    toEnum 0x40  = MinLinear
    toEnum 0x80  = MagLinear
    toEnum 0x100 = Mipmap
    toEnum 0x200 = NoPremultipliedAlpha
    toEnum 0x400 = VideoBitmap
    toEnum _     = error "BitmapFlags.toEnum: bad argument"
    fromEnum MemoryBitmap             = 1
    fromEnum KeepBitmapFormat         = 2
    fromEnum ForceLocking             = 4
    fromEnum NoPreserveTexture        = 8
    fromEnum AlphaTest                = 0x10
    fromEnum UnderscoreInternalOpenGL = 0x20
    fromEnum MinLinear                = 0x40
    fromEnum MagLinear                = 0x80
    fromEnum Mipmap                   = 0x100
    fromEnum NoPremultipliedAlpha     = 0x200
    fromEnum VideoBitmap              = 0x400

    succ x = toEnum (fromEnum x * 2)
    pred x = toEnum (fromEnum x `div` 2)

    enumFrom     x   = enumFromTo x maxBound
    enumFromTo x y | x > y = []
                   | x == y = [y]
                   | otherwise = x : enumFromTo (succ x) y

data BlittingFlags = FlipHorizontal
                   | FlipVertical
                     deriving (Show, Eq, Ord, Read)

instance Bounded BlittingFlags where
    minBound = FlipHorizontal
    maxBound = FlipVertical

instance Enum BlittingFlags where
    toEnum 1 = FlipHorizontal
    toEnum 2 = FlipVertical
    toEnum _ = error "BlittingFlags.toEnum: bad argument"
    fromEnum FlipHorizontal = 1
    fromEnum FlipVertical   = 2
    succ FlipHorizontal = FlipVertical
    succ _ = error "BlittingFlags.succ: bad argument"
    pred FlipVertical = FlipHorizontal
    pred _ = error "BlittingFlags.pred: bad argument"

    enumFrom     x   = enumFromTo x maxBound
    enumFromTo x y | x > y = []
                   | x == y = [y]
                   | otherwise = x : enumFromTo (succ x) y

data LockingFlags = LockReadWrite
                  | LockReadOnly
                  | LockWriteOnly
                    deriving (Show, Eq, Ord, Read)


instance Bounded LockingFlags where
    minBound = LockReadWrite
    maxBound = LockWriteOnly

instance Enum LockingFlags where
    toEnum 0 = LockReadWrite
    toEnum 1 = LockReadOnly
    toEnum 2 = LockWriteOnly
    toEnum _ = error "LockingFlags.toEnum: bad argument"
    fromEnum LockReadWrite = 0
    fromEnum LockReadOnly  = 1
    fromEnum LockWriteOnly = 2

    enumFrom     x   = enumFromTo     x   maxBound
    enumFromThen x y = enumFromThenTo x y maxBound

{#enum BLEND_MODE as BlendMode {underscoreToCase} deriving (Show, Eq, Ord, Read) #}
{#enum BLEND_OPERATIONS as BlendOperations {underscoreToCase} deriving (Show, Eq, Ord, Read) #}

{#fun unsafe al_set_new_bitmap_format as setNewBitmapFormat { cFromEnum `PixelFormat' } -> `()' #}
{#fun unsafe al_get_new_bitmap_format as getNewBitmapFormat { } -> `PixelFormat' cToEnum #}

{#fun unsafe al_set_new_bitmap_flags as setNewBitmapFlags { cFromEnumFlags `[BitmapFlags]' } -> `()' #}
{#fun unsafe al_get_new_bitmap_flags as getNewBitmapFlags { } -> `[BitmapFlags]' cToEnumFlags #}
{#fun unsafe al_add_new_bitmap_flag as addNewBitmapFlag { cFromEnumFlags `[BitmapFlags]' } -> `()' #}

{#fun unsafe al_get_bitmap_width as getBitmapWidth { id `Bitmap' } -> `Int' #}
{#fun unsafe al_get_bitmap_height as getBitmapHeight { id `Bitmap' } -> `Int' #}
{#fun unsafe al_get_bitmap_format as getBitmapFormat { id `Bitmap' } -> `PixelFormat' cToEnum #}
{#fun unsafe al_get_bitmap_flags as getBitmapFlags { id `Bitmap' } -> `[BitmapFlags]' cToEnumFlags #}
{#fun unsafe al_create_bitmap as  createBitmap { `Int', `Int' } -> `Bitmap' id #}
{#fun unsafe al_destroy_bitmap as destroyBitmap { id `Bitmap' } -> `()' #}

{#fun unsafe al_draw_bitmap as drawBitmap { id `Bitmap', `Float', `Float', cFromEnumFlags `[BlittingFlags]' } -> `()' #}
{#fun unsafe al_draw_bitmap_region as drawBitmapRegion { id `Bitmap', `Float', `Float', `Float', `Float', `Float', `Float', cFromEnumFlags `[BlittingFlags]'} -> `()' #}
{#fun unsafe al_draw_scaled_bitmap as drawScaledBitmap { id `Bitmap', `Float', `Float', `Float', `Float', `Float', `Float', `Float', `Float', cFromEnumFlags `[BlittingFlags]' } -> `()' #}
{#fun unsafe al_draw_rotated_bitmap as drawRotatedBitmap { id `Bitmap', `Float', `Float', `Float', `Float', `Float', cFromEnumFlags `[BlittingFlags]' } -> `()' #}
{#fun unsafe al_draw_scaled_rotated_bitmap as drawScaledRotatedBitmp { id `Bitmap', `Float', `Float', `Float', `Float', `Float', `Float', `Float', cFromEnumFlags `[BlittingFlags]' } -> `()' #}

{#fun unsafe al_draw_tinted_bitmap_w as drawTintedBitmap { id `Bitmap', withT* `Color', `Float', `Float', cFromEnumFlags `[BlittingFlags]' } -> `()' #}
{#fun unsafe al_draw_tinted_bitmap_region_w as drawTintedBitmapRegion { id `Bitmap', withT* `Color', `Float', `Float', `Float', `Float', `Float', `Float', cFromEnumFlags `[BlittingFlags]' } -> `()' #}
{#fun unsafe al_draw_tinted_scaled_bitmap_w as drawTintedScaledBitmapRegion { id `Bitmap', withT* `Color', `Float', `Float', `Float', `Float', `Float', `Float', `Float', `Float', cFromEnumFlags `[BlittingFlags]' } -> `()' #}
{#fun unsafe al_draw_tinted_rotated_bitmap_w as drawTintedRotatedBitmap { id `Bitmap', withT* `Color', `Float', `Float', `Float', `Float', `Float', cFromEnumFlags `[BlittingFlags]' } -> `()' #}
{#fun unsafe al_draw_tinted_scaled_rotated_bitmap_w as drawTintedScaledRotatedBitmap { id `Bitmap', withT* `Color', `Float', `Float', `Float', `Float', `Float', `Float', `Float', cFromEnumFlags `[BlittingFlags]' } -> `()' #}

{#fun unsafe al_put_pixel_w as putPixel { `Int', `Int', withT* `Color' } -> `()' #}
{#fun unsafe al_put_blended_pixel_w as putBlendedPixel { `Int', `Int', withT* `Color' } -> `()' #}
{#fun unsafe al_get_pixel_w as getPixel { id `Bitmap', `Int', `Int' } -> `Color' peek'n'free* #}

-- Elegantly skipping colour mapping and unmapping.

{#fun unsafe al_convert_mask_to_alpha_w as convertMaskToAlpha { id `Bitmap', withT* `Color' } -> `()' #}

{#fun unsafe al_set_clipping_rectangle as setClippingRectangle { `Int', `Int', `Int', `Int' } -> `()' #}
{#fun unsafe al_get_clipping_rectangle as getClippingRectangle { alloca- `Int' peek'n'cToInt*, alloca- `Int' peek'n'cToInt*, alloca- `Int' peek'n'cToInt*, alloca- `Int' peek'n'cToInt* } -> `()' #}

{#fun unsafe al_create_sub_bitmap as createSubBitmap { id `Bitmap', `Int', `Int', `Int', `Int' } -> `Bitmap' id #}
{#fun unsafe al_is_sub_bitmap as isSubBitmap { id `Bitmap' } -> `Bool' #}

{#fun unsafe al_clone_bitmap as cloneBitmap { id `Bitmap' } -> `Bitmap' id #}
{#fun unsafe al_is_bitmap_locked as isBitmapLocked { id `Bitmap' } -> `Bool' #}

{#fun unsafe al_set_blender as setBlender { cFromEnum `BlendOperations', cFromEnum `BlendMode', cFromEnum `BlendMode' } -> `()' #}
{#fun unsafe al_get_blender as getBlender { alloca- `BlendOperations' peek'n'cToEnum*, alloca- `BlendMode' peek'n'cToEnum*, alloca- `BlendMode' peek'n'cToEnum* } -> `()' #}
{#fun unsafe al_set_separate_blender as setSeparateBlender { cFromEnum `BlendOperations', cFromEnum `BlendMode', cFromEnum `BlendMode', cFromEnum `BlendOperations', cFromEnum `BlendMode', cFromEnum `BlendMode' } -> `()' #}
{#fun unsafe al_get_separate_blender as getSeparateBlender { alloca- `BlendOperations' peek'n'cToEnum*, alloca- `BlendMode' peek'n'cToEnum*, alloca- `BlendMode' peek'n'cToEnum*, alloca- `BlendOperations' peek'n'cToEnum*, alloca- `BlendMode' peek'n'cToEnum*, alloca- `BlendMode' peek'n'cToEnum* } -> `()' #}
