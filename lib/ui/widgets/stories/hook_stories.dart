import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:story_view/controller/story_controller.dart';

StoryController useStoryController() {
  return use(const _UseStoryControllerHook());
}

class _UseStoryControllerHook extends Hook<StoryController> {
  const _UseStoryControllerHook();

  @override
  _UseStoryControllerHookState createState() => _UseStoryControllerHookState();
}

class _UseStoryControllerHookState extends HookState<StoryController, _UseStoryControllerHook> {
  late StoryController _storyController;

  @override
  void initHook() {
    _storyController = StoryController();
  }

  @override
  void dispose() {
    _storyController.dispose();
  }

  @override
  StoryController build(BuildContext context) => _storyController;
}