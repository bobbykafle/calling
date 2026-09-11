import 'package:connectcall/models/call_model.dart';
import 'package:connectcall/screen/onboard/calls/bloc/calls_state.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallLogList extends StatelessWidget {
  const CallLogList({
    super.key,
    required this.state,
    required this.filter,
  });

  final CallLogState state;
  final CallLogFilter filter;

  @override
  Widget build(BuildContext context) {
    if (state.status == CallLogStatusEnum.initial || state.status == CallLogStatusEnum.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == CallLogStatusEnum.failure) {
      return Center(
        child: Text('Error: ${state.errorMessage}', style: const TextStyle(color: Colors.red)),
      );
    }

    final logs = state.filteredBy(filter);
    if (logs.isEmpty) {
      return const Center(
        child: Text('No calls found', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final isMissed = log.status == CallLogStatus.missed || log.status == CallLogStatus.declined;
        final isOutgoing = log.direction == CallDirection.outgoing;

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: context.primaryBlue.withOpacity(0.1),
              backgroundImage:
                  log.otherUserPhotoUrl.isNotEmpty ? NetworkImage(log.otherUserPhotoUrl) : null,
              child: log.otherUserPhotoUrl.isEmpty
                  ? Icon(CupertinoIcons.person_fill, color: context.primaryBlue)
                  : null,
            ),
            title: Text(log.otherUserName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Row(
              children: [
                Icon(
                  log.isVideoCall ? CupertinoIcons.video_camera_solid : CupertinoIcons.phone_fill,
                  size: 12,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Icon(
                  isMissed
                      ? CupertinoIcons.phone_down_fill
                      : (isOutgoing
                          ? CupertinoIcons.phone_arrow_up_right
                          : CupertinoIcons.phone_arrow_down_left),
                  size: 14,
                  color: isMissed ? Colors.red : Colors.green,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    isMissed ? 'Missed • ${_formatTime(log.timestamp)}' : _formatTime(log.timestamp),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            trailing: isMissed
                ? null
                : Text(log.formattedDuration, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final isToday = dt.year == now.year && dt.month == now.month && dt.day == now.day;
    final time = DateFormat('h:mm a').format(dt);
    if (isToday) return 'Today, $time';
    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = dt.year == yesterday.year && dt.month == yesterday.month && dt.day == yesterday.day;
    if (isYesterday) return 'Yesterday, $time';
    return '${DateFormat('MMM d').format(dt)}, $time';
  }
}