import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.completed = await queryTasksRecordOnce(
        queryBuilder: (tasksRecord) => tasksRecord.where(
          'completed',
          isEqualTo: true,
        ),
      );
      setState(() {
        _model.completedtasks = _model.completed!.length;
      });
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              StreamBuilder<List<TasksRecord>>(
                stream: queryTasksRecord(),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                    );
                  }
                  List<TasksRecord> progressBarTasksRecordList = snapshot.data!;
                  return CircularPercentIndicator(
                    percent: _model.completedtasks /
                        progressBarTasksRecordList.length,
                    radius: MediaQuery.sizeOf(context).width * 0.225,
                    lineWidth: 25,
                    animation: true,
                    animateFromLastPercent: true,
                    progressColor: FlutterFlowTheme.of(context).primary,
                    backgroundColor: FlutterFlowTheme.of(context).accent4,
                    center: Text(
                      formatNumber(
                        _model.completedtasks /
                            progressBarTasksRecordList.length,
                        formatType: FormatType.percent,
                      ),
                      style: FlutterFlowTheme.of(context).headlineSmall,
                    ),
                  );
                },
              ),
              StreamBuilder<List<TasksRecord>>(
                stream: queryTasksRecord(),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                    );
                  }
                  List<TasksRecord> listViewTasksRecordList = snapshot.data!;
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listViewTasksRecordList.length,
                    itemBuilder: (context, listViewIndex) {
                      final listViewTasksRecord =
                          listViewTasksRecordList[listViewIndex];
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ToggleIcon(
                              onPressed: () async {
                                await listViewTasksRecord.reference.update({
                                  ...mapToFirestore(
                                    {
                                      'completed':
                                          !listViewTasksRecord.completed,
                                    },
                                  ),
                                });
                                if (listViewTasksRecord.completed) {
                                  setState(() {
                                    _model.completedtasks =
                                        _model.completedtasks + -1;
                                  });
                                } else {
                                  setState(() {
                                    _model.completedtasks =
                                        _model.completedtasks + 1;
                                  });
                                }
                              },
                              value: listViewTasksRecord.completed,
                              onIcon: Icon(
                                Icons.check_box,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 25,
                              ),
                              offIcon: Icon(
                                Icons.check_box_outline_blank,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 25,
                              ),
                            ),
                            Text(
                              listViewTasksRecord.name,
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
