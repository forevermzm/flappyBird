// Generated by Apple Swift version 2.1 (swiftlang-700.1.101.6 clang-700.1.76)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if defined(__has_include) && __has_include(<uchar.h>)
# include <uchar.h>
#elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
#endif

typedef struct _NSZone NSZone;

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted) 
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
#endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import SpriteKit;
@import CoreGraphics;
@import Foundation;
@import CoreFoundation;
@import Dispatch;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIWindow;
@class UIApplication;
@class NSObject;

SWIFT_CLASS("_TtC10FlappyBird11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow * __nullable window;
- (BOOL)application:(UIApplication * __nonnull)application didFinishLaunchingWithOptions:(NSDictionary * __nullable)launchOptions;
- (void)applicationWillResignActive:(UIApplication * __nonnull)application;
- (void)applicationDidEnterBackground:(UIApplication * __nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * __nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * __nonnull)application;
- (void)applicationWillTerminate:(UIApplication * __nonnull)application;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class SKNode;
@class SKAction;
@class SKSpriteNode;
@class SKView;
@class UITouch;
@class UIEvent;
@class NSCoder;

SWIFT_CLASS("_TtC10FlappyBird9GameScene")
@interface GameScene : SKScene
@property (nonatomic, readonly) CGFloat kGravity;
@property (nonatomic, readonly) CGFloat kImpulse;
@property (nonatomic, readonly) CGFloat FOREGROUND_SPEED;
@property (nonatomic, readonly, copy) NSString * __nonnull FOREGROUND_NAME;
@property (nonatomic, readonly, strong) SKNode * __nonnull worldNode;
@property (nonatomic) CGFloat playableStart;
@property (nonatomic) CGFloat playableHeight;
@property (nonatomic, readonly, strong) SKAction * __nonnull dingAction;
@property (nonatomic, readonly, strong) SKAction * __nonnull flapAction;
@property (nonatomic, readonly, strong) SKAction * __nonnull whackAction;
@property (nonatomic, readonly, strong) SKAction * __nonnull fallingAction;
@property (nonatomic, readonly, strong) SKAction * __nonnull hitGroundAction;
@property (nonatomic, readonly, strong) SKAction * __nonnull popAction;
@property (nonatomic, readonly, strong) SKAction * __nonnull coinAction;
@property (nonatomic, readonly, strong) SKSpriteNode * __nonnull player;
@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval dt;
@property (nonatomic) CGPoint playerVelocity;
- (void)didMoveToView:(SKView * __nonnull)view;
- (void)setupBackground;
- (void)setupForeground;
- (void)setupPlayer;
- (void)touchesBegan:(NSSet<UITouch *> * __nonnull)touches withEvent:(UIEvent * __nullable)event;
- (void)flapPlayer;
- (void)update:(CFTimeInterval)currentTime;
- (void)updatePlayer;
- (void)updateForeground;
- (nonnull instancetype)initWithSize:(CGSize)size OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSBundle;

SWIFT_CLASS("_TtC10FlappyBird18GameViewController")
@interface GameViewController : UIViewController
- (void)viewWillLayoutSubviews;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (BOOL)prefersStatusBarHidden;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface SKAction (SWIFT_EXTENSION(FlappyBird))
@end


@interface SKAction (SWIFT_EXTENSION(FlappyBird))

/// Performs an action after the specified delay.
+ (SKAction * __nonnull)afterDelay:(NSTimeInterval)delay performAction:(SKAction * __nonnull)action;

/// Performs a block after the specified delay.
+ (SKAction * __nonnull)afterDelay:(NSTimeInterval)delay runBlock:(void (^ __nonnull)(void))block;

/// Removes the node from its parent after the specified delay.
+ (SKAction * __nonnull)removeFromParentAfterDelay:(NSTimeInterval)delay;

/// Creates an action to perform a parabolic jump.
+ (SKAction * __nonnull)jumpToHeight:(CGFloat)height duration:(NSTimeInterval)duration originalPosition:(CGPoint)originalPosition;
@end


@interface SKAction (SWIFT_EXTENSION(FlappyBird))

/// Creates a screen shake animation.
///
/// @param node The node to shake. You cannot apply this effect to an SKScene.
/// @param amount The vector by which the node is displaced.
/// @param oscillations The number of oscillations; 10 is a good value.
/// @param duration How long the effect lasts. Shorter is better.
+ (SKAction * __nonnull)screenShakeWithNode:(SKNode * __nonnull)node amount:(CGPoint)amount oscillations:(NSInteger)oscillations duration:(NSTimeInterval)duration;

/// Creates a screen rotation animation.
///
/// @param node You usually want to apply this effect to a pivot node that is
/// centered in the scene. You cannot apply the effect to an SKScene.
/// @param angle The angle in radians.
/// @param oscillations The number of oscillations; 10 is a good value.
/// @param duration How long the effect lasts. Shorter is better.
+ (SKAction * __nonnull)screenRotateWithNode:(SKNode * __nonnull)node angle:(CGFloat)angle oscillations:(NSInteger)oscillations duration:(NSTimeInterval)duration;

/// Creates a screen zoom animation.
///
/// @param node You usually want to apply this effect to a pivot node that is
/// centered in the scene. You cannot apply the effect to an SKScene.
/// @param amount How much to scale the node in the X and Y directions.
/// @param oscillations The number of oscillations; 10 is a good value.
/// @param duration How long the effect lasts. Shorter is better.
+ (SKAction * __nonnull)screenZoomWithNode:(SKNode * __nonnull)node amount:(CGPoint)amount oscillations:(NSInteger)oscillations duration:(NSTimeInterval)duration;

/// Causes the scene background to flash for duration seconds.
+ (SKAction * __nonnull)colorGlitchWithScene:(SKScene * __nonnull)scene originalColor:(UIColor * __nonnull)originalColor duration:(NSTimeInterval)duration;
@end


@interface SKNode (SWIFT_EXTENSION(FlappyBird))

/// Lets you treat the node's scale as a CGPoint value.
@property (nonatomic) CGPoint scaleAsPoint;

/// Runs an action on the node that performs a closure or function after a given time.
- (void)afterDelay:(NSTimeInterval)delay runBlock:(void (^ __nonnull)(void))block;

/// Makes this node the frontmost node in its parent.
- (void)bringToFront;

/// Orients the node in the direction that it is moving by tweening its rotation angle. This assumes that at 0 degrees the node is facing up.
///
/// @param velocity The current speed and direction of the node. You can get
/// this from node.physicsBody.velocity.
/// @param rate How fast the node rotates. Must have a value between 0.0 and
/// 1.0, where smaller means slower; 1.0 is instantaneous.
- (void)rotateToVelocity:(CGVector)velocity rate:(CGFloat)rate;
@end

#pragma clang diagnostic pop