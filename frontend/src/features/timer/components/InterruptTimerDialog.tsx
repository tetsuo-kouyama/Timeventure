import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";

type Props = {
  open: boolean
  onOpenChange: (open: boolean) => void
  onInterrupt: () => void
}

export function InterruptTimerDialog({
  open,
  onOpenChange,
  onInterrupt,
}: Props) {
  return (
    <AlertDialog
      open={open}
      onOpenChange={onOpenChange}
    >
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>
            タイマーを中断しますか？
          </AlertDialogTitle>

          <AlertDialogDescription>
            中断するとタイマーは終了します。
          </AlertDialogDescription>
        </AlertDialogHeader>

        <AlertDialogFooter>
          <AlertDialogCancel>
            戻る
          </AlertDialogCancel>

          <AlertDialogAction onClick={onInterrupt}>
            中断する
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  )
}
      
