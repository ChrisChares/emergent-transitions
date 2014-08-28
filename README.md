emergent-transitions
====================

Facebook news feed style view controller transitions utilizing iOS 8's UIPresentationController

When a new view is presented, the heirarchy looks as follows
````
<UITransitionView>
	<UIView>[Presenting View]</UIView>
	<UIView>[Emergent View]</UIView>
	<UIView>[Presented View]</UIView>
</UITransitionView>
````