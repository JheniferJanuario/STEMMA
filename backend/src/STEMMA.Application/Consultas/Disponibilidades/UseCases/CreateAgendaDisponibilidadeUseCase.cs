using STEMMA.Application.Consultas.Disponibilidades.DTOs.Requests;
using STEMMA.Domain.Consultas.Entities;
using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Application.Consultas.Disponibilidades.UseCases;

public class CreateAgendaDisponibilidadeUseCase
{
    private readonly IDisponibilidadeRepository _repository;

    public CreateAgendaDisponibilidadeUseCase(
        IDisponibilidadeRepository repository)
    {
        _repository = repository;
    }

    public async Task ExecuteAsync(CreateAgendaDisponibilidadeRequest request)
    {
        var inicio = request.Data.Date.Add(request.HoraInicio);
        var fim = request.Data.Date.Add(request.HoraFim);

        if (fim <= inicio)
            throw new Exception("Horário final deve ser maior que o inicial.");

        var horarioAtual = inicio;
        //loop que trava o pc
        while (horarioAtual.AddMinutes(request.DuracaoMinutos) <= fim)
        {
            var horarioFim = horarioAtual.AddMinutes(request.DuracaoMinutos);

            var existeConflito = await _repository.ExisteConflitoAsync(
                request.VeterinarioId,
                horarioAtual,
                horarioFim);

            if (!existeConflito)
            {
                var disponibilidade = new Disponibilidade(
                    request.VeterinarioId,
                    horarioAtual,
                    horarioFim);

                await _repository.AdicionarAsync(disponibilidade);
            }

            horarioAtual = horarioFim;
        }
    }
}