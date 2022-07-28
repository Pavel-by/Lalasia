import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

typedef AdaptiveBuildCallback<StateIdentifier> = Widget Function(
  BuildContext context,
  StateIdentifier stateIdentifier,
  BoxConstraints constraints,
);
typedef AdaptiveCheckCallback<StateIdentifier> = StateIdentifier Function(
  AdaptiveInfo<StateIdentifier> info,
);
typedef AdaptiveLayoutCallback<StateIdentifier> = void Function(
  StateIdentifier stateIdentifier,
  BoxConstraints constraints,
);

enum AdaptiveLayoutResult { great, oversize }

class AdaptiveInfo<StateIdentifier> {
  final StateIdentifier stateIdentifier;
  final AdaptiveLayoutResult layoutResult;

  AdaptiveInfo(this.stateIdentifier, this.layoutResult);
}

class AdaptiveLayoutBuilder<StateIdentifier> extends RenderObjectWidget {
  final StateIdentifier initialStateIdentifier;
  final AdaptiveBuildCallback<StateIdentifier> buildCallback;
  final AdaptiveCheckCallback<StateIdentifier> checkCallback;

  const AdaptiveLayoutBuilder({
    Key? key,
    required this.initialStateIdentifier,
    required this.buildCallback,
    required this.checkCallback,
  }) : super(key: key);

  @override
  RenderObjectElement createElement() {
    return _AdaptiveLayoutBuilderElement<StateIdentifier>(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderAdaptiveLayoutBuilder<StateIdentifier>();
  }
}

class _AdaptiveLayoutBuilderElement<StateIdentifier>
    extends RenderObjectElement {
  _AdaptiveLayoutBuilderElement(AdaptiveLayoutBuilder<StateIdentifier> widget)
      : super(widget);

  @override
  RenderAdaptiveLayoutBuilderMixin<StateIdentifier> get renderObject =>
      super.renderObject as RenderAdaptiveLayoutBuilderMixin<StateIdentifier>;

  @override
  AdaptiveLayoutBuilder<StateIdentifier> get widget =>
      super.widget as AdaptiveLayoutBuilder<StateIdentifier>;

  Element? _child;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_child != null) {
      visitor(_child!);
    }
  }

  @override
  void forgetChild(Element child) {
    assert(child == _child);
    _child = null;
    super.forgetChild(child);
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    renderObject.updateInitialStateIdentifier(widget.initialStateIdentifier);
    renderObject.updateLayoutCallback(_layout);
    renderObject.updateCheckCallback(widget.checkCallback);
  }

  @override
  void update(AdaptiveLayoutBuilder<StateIdentifier> newWidget) {
    assert(widget != newWidget);
    super.update(newWidget);
    assert(widget == newWidget);

    renderObject.updateInitialStateIdentifier(widget.initialStateIdentifier);
    renderObject.updateLayoutCallback(_layout);
    renderObject.updateCheckCallback(widget.checkCallback);
    renderObject.markNeedsBuild();
  }

  @override
  void performRebuild() {
    renderObject.markNeedsBuild();
    super.performRebuild();
  }

  @override
  void unmount() {
    renderObject.updateInitialStateIdentifier(null);
    renderObject.updateLayoutCallback(null);
    renderObject.updateCheckCallback(null);
    super.unmount();
  }

  void _layout(StateIdentifier stateIdentifier, BoxConstraints constraints) {
    @pragma('vm:notify-debugger-on-exception')
    void layoutCallback() {
      Widget built;
      try {
        built = widget.buildCallback(this, stateIdentifier, constraints);
        debugWidgetBuilderValue(widget, built);
      } catch (e, stack) {
        built = ErrorWidget.builder(
          _debugReportException(
            ErrorDescription('building $widget'),
            e,
            stack,
            informationCollector: () => <DiagnosticsNode>[
              if (kDebugMode) DiagnosticsDebugCreator(DebugCreator(this)),
            ],
          ),
        );
      }
      try {
        _child = updateChild(_child, built, null);
        assert(_child != null);
      } catch (e, stack) {
        built = ErrorWidget.builder(
          _debugReportException(
            ErrorDescription('building $widget'),
            e,
            stack,
            informationCollector: () => <DiagnosticsNode>[
              if (kDebugMode) DiagnosticsDebugCreator(DebugCreator(this)),
            ],
          ),
        );
        _child = updateChild(null, built, slot);
      }
    }

    owner!.buildScope(this, layoutCallback);
  }

  @override
  void insertRenderObjectChild(RenderObject child, Object? slot) {
    final RenderObjectWithChildMixin<RenderObject> renderObject =
        this.renderObject;
    assert(slot == null);
    assert(renderObject.debugValidateChild(child));
    renderObject.child = child;
    assert(renderObject == this.renderObject);
  }

  @override
  void moveRenderObjectChild(
      RenderObject child, Object? oldSlot, Object? newSlot) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(RenderObject child, Object? slot) {
    final RenderAdaptiveLayoutBuilderMixin<StateIdentifier> renderObject =
        this.renderObject;
    assert(renderObject.child == child);
    renderObject.child = null;
    assert(renderObject == this.renderObject);
  }
}

mixin RenderAdaptiveLayoutBuilderMixin<StateIdentifier>
    on RenderBox, RenderObjectWithChildMixin<RenderBox> {
  StateIdentifier? _initialStateIdentifier;
  AdaptiveLayoutCallback<StateIdentifier>? _layoutCallback;

  AdaptiveCheckCallback<StateIdentifier>? _checkCallback;
  AdaptiveCheckCallback<StateIdentifier> get checkCallback => _checkCallback!;

  void updateInitialStateIdentifier(StateIdentifier? value) {
    if (value == _initialStateIdentifier) return;
    _initialStateIdentifier = value;
    _resetStateIdentifier();
    markNeedsLayout();
  }

  void updateLayoutCallback(AdaptiveLayoutCallback<StateIdentifier>? value) {
    if (value == _layoutCallback) return;
    _layoutCallback = value;
    _resetStateIdentifier();
    markNeedsLayout();
  }

  void updateCheckCallback(AdaptiveCheckCallback<StateIdentifier>? value) {
    if (value == _checkCallback) return;
    _checkCallback = value;
    _resetStateIdentifier();
    markNeedsLayout();
  }

  void markNeedsBuild() {
    _needsBuild = true;
    markNeedsLayout();
  }

  void _resetStateIdentifier() {
    _stateIdentifier = _initialStateIdentifier;
  }

  bool _needsBuild = true;
  BoxConstraints? _previousConstraints;
  StateIdentifier? _previousStateIdentifier;

  StateIdentifier? _stateIdentifier;
  StateIdentifier get stateIdentifier => _stateIdentifier!;
  set stateIdentifier(StateIdentifier value) {
    _stateIdentifier = value;
  }

  bool rebuildIfNecessary() {
    assert(_layoutCallback != null);
    assert(_checkCallback != null);

    _needsBuild |= _previousConstraints != constraints ||
        _previousStateIdentifier != stateIdentifier;
    _previousConstraints = constraints;
    _previousStateIdentifier = stateIdentifier;

    if (_needsBuild) {
      invokeLayoutCallback((constraints) => _layoutCallback!(
            _previousStateIdentifier as StateIdentifier,
            _previousConstraints!,
          ));
    }

    return _needsBuild;
  }
}

class RenderAdaptiveLayoutBuilder<StateIdentifier> extends RenderBox
    with
        RenderObjectWithChildMixin<RenderBox>,
        RenderAdaptiveLayoutBuilderMixin<StateIdentifier> {
  @override
  double computeMinIntrinsicWidth(double height) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(debugCannotComputeDryLayout(
      reason:
          'Calculating the dry layout would require running the layout callback '
          'speculatively, which might mutate the live render object tree.',
    ));
    return Size.zero;
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;

    if (rebuildIfNecessary()) {
      child?.layout(constraints, parentUsesSize: true);
      size = child != null
          ? constraints.constrain(child!.size)
          : constraints.biggest;
      return;
    }

    child!.layout(constraints, parentUsesSize: true);
    AdaptiveLayoutResult layoutResult = constraints.isSatisfiedBy(child!.size)
        ? AdaptiveLayoutResult.great
        : AdaptiveLayoutResult.oversize;
    stateIdentifier = checkCallback(AdaptiveInfo<StateIdentifier>(
      stateIdentifier,
      layoutResult,
    ));

    if (rebuildIfNecessary()) {
      size = constraints.biggest;
      return;
    }

    size = constraints.constrain(child!.size);
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    if (child != null) return child!.getDistanceToActualBaseline(baseline);
    return super.computeDistanceToActualBaseline(baseline);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return child?.hitTest(result, position: position) ?? false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) context.paintChild(child!, offset);
  }

  bool _debugThrowIfNotCheckingIntrinsics() {
    assert(() {
      if (!RenderObject.debugCheckingIntrinsics) {
        throw FlutterError(
          'AdptiveLayoutBuilder does not support returning intrinsic dimensions.\n'
          'Calculating the intrinsic dimensions would require running the layout '
          'callback speculatively, which might mutate the live render object tree.',
        );
      }
      return true;
    }());

    return true;
  }
}

FlutterErrorDetails _debugReportException(
  DiagnosticsNode context,
  Object exception,
  StackTrace stack, {
  InformationCollector? informationCollector,
}) {
  final FlutterErrorDetails details = FlutterErrorDetails(
    exception: exception,
    stack: stack,
    context: context,
    informationCollector: informationCollector,
  );
  FlutterError.reportError(details);
  return details;
}
