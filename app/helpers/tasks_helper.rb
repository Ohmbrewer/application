module TasksHelper

  def task_li(task)
    content_tag(:li) do
      content_tag(:ul) do
        content_tag(:li, "Type: #{task.type}")
        concat content_tag(:li, "Status: #{task.status.titlecase}")
        concat content_tag(:li, "Stop Time: #{task.status.titlecase}")
      end
    end
  end

  def tasks_list(root_task)
    content_tag(:ul) do
      subhash_tasks_list(root_task.hash_tree)
    end
  end

  def subhash_tasks_list(subhash)
    subhash.each do |t, sh|
      task_li(t)
      concat subhash_tasks_list(subhash)
    end
  end

end
